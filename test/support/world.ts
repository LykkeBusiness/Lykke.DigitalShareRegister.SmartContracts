import { DataTable, setWorldConstructor } from '@cucumber/cucumber'
import { TransactionResponse } from '@ethersproject/abstract-provider';
import { Contract } from '@ethersproject/contracts';
import { ethers } from 'hardhat';
import { TransactionExecutionResult } from './contracts';
import { actors, contracts } from '.';


// const contracts: string[][] = [
//   ["'only to registered shareholder' rule", "OnlyToRegisteredShareholder"],
//   ["shares token rule engine", "SharesTokenRuleEngine"]
// ];


export class World {
  // Static

  private static readonly _contractDefinitions: Map<string, string> = new Map<string, string>();
  
  public static registerContractDefinition(
    definition: string,
    name: string
  ) {

    if (World._contractDefinitions.has(definition)) {
      throw new Error(`Contract definition [${definition}] has already been registered.`)
    }

    World._contractDefinitions.set(definition, name);;

  }

  private static async _getContractName(
    contractId: string
  ) {

    for (let definition of Array.from(this._contractDefinitions.keys())) {
      if (contractId.endsWith(definition)) {
        return World._contractDefinitions.get(definition);
      }
    }
  
    throw new Error(`Contract id ['${contractId}'] refers to an unknown contract.`);

  }

  // Instance

  private readonly _callResults: any[] = [];
  private readonly _contracts: Map<string, string> = new Map<string, string>();
  private readonly _transactions: TransactionExecutionResult[] = [];

  private _activeCallResultId: number = 0;
  private _activeTxId: number = 0;


  public async callContract(
    contractId: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<any>,
    options?: {
      caller?: string,
      args?: DataTable | any[]
    }
  ) {

    const callResult = await contracts.call(
      await actors.get(options?.caller), 
      await World._getContractName(contractId),
      this._contracts.get(contractId),
      functionSelector,
      await this._preprocessArgs(options?.args)
    );

    this._callResults.push(callResult);

  }

  public async deployContract(
    contractId: string,
    options?: {
      deployer?: string,
      args?: DataTable | any[]
    }
  ) {

    await this._deployContract(
      contractId,
      options?.deployer,
      options?.args,
      { registerTx: false, throwOnError: true }
    );

  }

  public async deployContractAndRegisterTx(
    contractId: string,
    options?: {
      deployer?: string,
      args?: DataTable | any[]
    }
  ) {

    await this._deployContract(
      contractId,
      options?.deployer,
      options?.args,
      { registerTx: true, throwOnError: false }
    );

  }

  public async executeTx(
    contractId: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<TransactionResponse>,
    options?: {
      executor?: string,
      args?: DataTable | any[]
    }
  ) {

    await this._executeTx(
      contractId,
      functionSelector,
      options?.executor,
      options?.args,
      { registerTx: false, throwOnError: true }
    );

  }

  public async executeAndRegisterTx(
    contractId: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<TransactionResponse>,
    options?: {
      executor?: string,
      args?: DataTable | any[]
    }
  ) {

    await this._executeTx(
      contractId,
      functionSelector,
      options?.executor,
      options?.args,
      { registerTx: true, throwOnError: false }
    );

  }

  public getCallResult(
    callId?: number
  ) {

    if (callId !== undefined) {
      this._activeCallResultId = callId;
    }

    return this._callResults[this._activeCallResultId];

  }

  public async reproduceTransaction(
    transactionId?: number
  ) {
    
    if (transactionId !== undefined) {
      this._activeTxId = transactionId;
    }

    const txExecutionResult = this._transactions[this._activeTxId];
    const txReceipt = await ethers.provider.getTransactionReceipt(txExecutionResult.txHash);
    
    if (txReceipt.status === 1) {
      return txReceipt;
    } else {
      throw txExecutionResult.error;
    }
  
  }

  public async translateExpectedValue(
    expectedValue: string
  ) {
    return await this._preprocessValue(expectedValue);
  }

  private async _deployContract(
    contractId: string,
    deployer: string,
    args: DataTable | any[],
    options: { registerTx: boolean, throwOnError: boolean }
  ) {

    const contractDeploymentResult = await contracts.deploy(
      await actors.get(deployer), 
      await World._getContractName(contractId),
      await this._preprocessArgs(args)
    );

    if (contractDeploymentResult.error && options.throwOnError) {
      throw contractDeploymentResult.error;
    }

    if (options.registerTx) {
      this._transactions.push(contractDeploymentResult);
    }

    this._contracts.set(contractId, contractDeploymentResult.contractAddress);

  }

  private async _executeTx(
    contractId: string,
    functionSelector: (contract: Contract) => (...args: any[]) => Promise<TransactionResponse>,
    executor: string,
    args: DataTable | any[],
    options: { registerTx: boolean, throwOnError: boolean }
  ) {

    const transactionExecutionResult = await contracts.executeTx(
      await actors.get(executor), 
      await World._getContractName(contractId),
      this._contracts.get(contractId),
      functionSelector,
      await this._preprocessArgs(args)
    );

    if (transactionExecutionResult.error && options.throwOnError) {
      throw transactionExecutionResult.error;
    }

    if (options.registerTx) {
      this._transactions.push(transactionExecutionResult);
    }

  }

  private async _preprocessArgs(
    txArgs: DataTable | any[]
  ) {
    const result = [];

    if (txArgs instanceof DataTable) {
      for (let txArg of txArgs?.hashes() ?? []) {
        result.push(await this._preprocessValue(txArg.Value));
      }
    } else {
      for (let txArg of txArgs ?? []) {
        result.push(await this._preprocessValue(txArg));
      }
    }

    return result;
  }

  private async _preprocessValue(
    txArg: string
  ) {

    if (txArg === 'zero address') {
        return '0x0000000000000000000000000000000000000000';
    }

    if (txArg === 'my address') {
        return (await actors.get()).address;
    }

    if (actors.isKnown(txArg)) {
      return (await actors.get(txArg)).address;
    }

    const contractIdMatch = txArg.match(/^address of (.*) smart contract$/);
    if (contractIdMatch) {
        return this._contracts.get(contractIdMatch[1]);
    }

    const actorIdMatch = txArg.match(/^address of (.*)$/);
    if (actorIdMatch) {
      return (await actors.get(actorIdMatch[1])).address;
    }
    
    return txArg;

  }
}


setWorldConstructor(World)