import { When } from '@cucumber/cucumber'
import { World } from '../../support'

const defaultContractId = 'ownable by shares token issuer';
const contractDefinition = World.registerContractDefinition(defaultContractId, 'OwnableBySharesTokenIssuerMock');

When(
  /^I call for a protected action of the ownable by shares token issuer smart contract$/,
  async function (
    this: World
  ) {
    await this.executeAndRegisterTx(
      defaultContractId,
      (c) => c.functionCallableOnlyBySharesTokenIssuer
    );
  }
);

When(
  /^(.*) calls for a protected action of the ownable by shares token issuer smart contract$/,
  async function (
    this: World,
    executor: string
  ) {
    await this.executeAndRegisterTx(
      defaultContractId,
      (c) => c.functionCallableOnlyBySharesTokenIssuer,
      { executor }
    );
  }
);

When(
  /^I call ownable by shares token issuer smart contract for shares token address$/,
  async function (
    this: World
  ) {
    await this.callContract(
      defaultContractId,
      (c) => c.sharesToken,
    )
  }
);