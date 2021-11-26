import { TransactionResponse } from '@ethersproject/abstract-provider';
import { Signer } from '@ethersproject/abstract-signer';
import { Contract } from '@ethersproject/contracts';
import { ethers } from 'hardhat';


export class TransactionExecutionResult {
    private readonly _error: any;
    private readonly _txHash: string;
  
    public constructor(
      txHash: string,
      error?: any
    ) {
      this._error = error;
      this._txHash = txHash;
    }
  
    public get error() {
      return this._error;
    }
  
    public get txHash() {
      return this._txHash;
    }
}

export class ContractDeploymentResult extends TransactionExecutionResult {
    private readonly _contractAddress: string;

    public constructor(
        txHash: string,
        contractAddress?: string,
        error?: any
      ) {
          super(txHash, error);
          this._contractAddress = contractAddress;
      }

      public get contractAddress() {
        return this._contractAddress;
      }
}


export async function call(
    caller: Signer,
    contractName: string,
    contractAddress: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<any>,
    args: any[]
) {

    const contractFactory = await ethers.getContractFactory(contractName, caller);
    const contract = contractFactory.attach(contractAddress);

    return await functionSelector(contract)(...args);

}

export async function deploy(
    deployer: Signer,
    contractName: string,
    args: any[]
): Promise<ContractDeploymentResult> {

    let contractAddress: string;
    let deploymentError: any;
    let transactionHash: string;

    try {
        
        const contractFactory = await ethers.getContractFactory(contractName, deployer);
        const contract = await contractFactory.deploy(...args, { gasLimit: 30000000 });

        contractAddress = contract.address;
        transactionHash = contract.deployTransaction.hash;
        
    } catch (error) {

        if(typeof error === 'object' && error.hasOwnProperty('transactionHash')) {
            deploymentError = error;
            transactionHash = error.transactionHash;
        } else {
            throw error;
        }

    }

    return new ContractDeploymentResult(
        transactionHash,
        contractAddress,
        deploymentError
    );
}

export async function executeTx(
    executor: Signer,
    contractName: string,
    contractAddress: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<TransactionResponse>,
    args: any[]
) {

    let executionError: any;
    let transactionHash: string;

    try {

        const contractFactory = await ethers.getContractFactory(contractName, executor);
        const contract = contractFactory.attach(contractAddress);

        const txResponse = await functionSelector(contract)(...args, { gasLimit: 30000000 });
        const txReceipt = await txResponse.wait();

        transactionHash = txReceipt.transactionHash;

    } catch (error) {

        if(typeof error === 'object' && error.hasOwnProperty('transactionHash')) {
            executionError = error;
            transactionHash = error.transactionHash;
        } else {
            throw error;
        }

    }

    return new TransactionExecutionResult(
        transactionHash,
        executionError
    );

}