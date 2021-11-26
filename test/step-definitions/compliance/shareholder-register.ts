import { Given, When } from '@cucumber/cucumber'
import { World } from '../../support'

const defaultContractId = 'shareholder register';
const contractDefinition = World.registerContractDefinition(defaultContractId, 'ShareholderRegister');

Given(
    /^(.*) excluded (.*) from shareholder register$/,
    async function (
      this: World,
      executor: string,
      account: string
    ) {
        await this.executeTx(
            defaultContractId,
            (c) => c.excludeShareholder,
            { executor, args: [account] }
        )
    }
  );

Given(
    /^(.*) included (.*) into shareholder register$/,
    async function (
      this: World,
      executor: string,
      account: string
    ) {
        await this.executeTx(
            defaultContractId,
            (c) => c.includeShareholder,
            { executor, args: [account] }
        )
    }
  );

When(
    /^I exclude (.*) from shareholder register$/,
    async function (
      this: World,
      account: string
    ) {
        await this.executeAndRegisterTx(
            defaultContractId,
            (c) => c.excludeShareholder,
            { args: [account] }
        )
    }
  );
  
When(
    /^(.*) excludes (.*) from shareholder register$/,
    async function (
      this: World,
      executor: string,
      account: string
    ) {
        await this.executeAndRegisterTx(
            defaultContractId,
            (c) => c.excludeShareholder,
            { executor, args: [account] }
        )
    }
);

When(
    /^I include (.*) into shareholder register$/,
    async function (
      this: World,
      account: string
    ) {
        await this.executeAndRegisterTx(
            defaultContractId,
            (c) => c.includeShareholder,
            { args: [account] }
        )
    }
);
  
When(
    /^(.*) includes (.*) into shareholder register$/,
    async function (
      this: World,
      executor: string,
      account: string
    ) {
        await this.executeAndRegisterTx(
            defaultContractId,
            (c) => c.includeShareholder,
            { executor, args: [account] }
        )
    }
);

When(
    /^I call shareholder register smart contract for the number of shareholders$/,
    async function (
      this: World
    ) {
        await this.callContract(
            defaultContractId,
            (c) => c.countShareholders,
        )
    }
);

When(
    /^I call shareholder register smart contract if (.*) is a shareholder$/,
    async function (
      this: World,
      account: string
    ) {
        await this.callContract(
            defaultContractId,
            (c) => c.isShareholder,
            { args: [account] }
        )
    }
);

When(
    /^I call shareholder register smart contract for the shareholder with index (.*)$/,
    async function (
      this: World,
      index: number
    ) {
        await this.callContract(
            defaultContractId,
            (c) => c.shareholderAt,
            { args: [index] }
        )
    }
);