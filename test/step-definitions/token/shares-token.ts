import { When } from '@cucumber/cucumber'
import { World } from '../../support'

const defaultContractId = 'shares token';
const contractDefinition = World.registerContractDefinition(defaultContractId, 'SharesToken');

When(
    /^(.*) issues (.*) shares$/,
    async function (
      this: World,
      executor: string,
      amount: string
    ) {
      await this.executeAndRegisterTx(
        defaultContractId,
        (c) => c.issue,
        { executor, args: [amount] }
      );
    }
  );