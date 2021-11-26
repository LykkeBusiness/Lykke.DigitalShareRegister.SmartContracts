import { DataTable, Given, When } from '@cucumber/cucumber'
import { World } from '../support'


Given(
    /^(.*) smart contract is deployed$/,
    async function (
        this: World,
        contractId: string
    ) {
        await this.deployContract(contractId);
    }
)

Given(
    /^(.*) smart contract is deployed by (.*)$/,
    async function (
        this: World,
        contractId: string,
        deployer: string
    ) {
        await this.deployContract(contractId, { deployer });
    }
)

Given(
    /^(.*) smart contract is deployed with the parameters:$/,
    async function (
        this: World,
        contractId: string,
        args: DataTable
    ) {
        await this.deployContract(contractId, { args });
    }
)

Given(
    /^(.*) smart contract is deployed by (.*) with the parameters:$/,
    async function (
        this: World,
        contractId: string,
        deployer: string,
        args: DataTable
    ) {
        await this.deployContract(contractId, { deployer, args });
    }
)

When(
    /^I deploy (.*) smart contract$/,
    async function (
        this: World,
        contractId: string
    ) {
        await this.deployContractAndRegisterTx(contractId);
    }
)

When(
    /^I deploy (.*) smart contract with the parameters:$/,
    async function (
        this: World,
        contractId: string,
        args: DataTable
    ) {
        await this.deployContractAndRegisterTx(contractId, { args });
    }
)

When(
    /^(.*) deploys (.*) smart contract$/,
    async function (
        this: World,
        deployer: string,
        contractId: string
    ) {
        await this.deployContractAndRegisterTx(contractId, { deployer });
    }
)

When(
    /^(.*) deploys (.*) smart contract with the parameters:$/,
    async function (
        this: World,
        deployer: string,
        contractId: string,
        args: DataTable
    ) {
        await this.deployContractAndRegisterTx(contractId, { deployer, args });
    }
)