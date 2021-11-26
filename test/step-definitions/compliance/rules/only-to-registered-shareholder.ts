import { Given, When } from '@cucumber/cucumber'
import { World } from '../../../support'

const defaultContractId = 'only to registered shareholder rule';
const contractDefinition = World.registerContractDefinition(defaultContractId, 'OnlyToRegisteredShareholder');

When(
    /^I call only to registered shareholder rule smart contract if transfer of 1 LKK from me to (.*) is allowed$/,
    async function (
      this: World,
      account: string
    ) {
        await this.callContract(
            defaultContractId,
            (c) => c.transferIsAllowed,
            { args: ['Narrator', account, '1000000000000000000'] }
        )
    }
);