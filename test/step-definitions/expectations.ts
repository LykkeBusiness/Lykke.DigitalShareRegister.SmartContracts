import * as chai from "chai";
import { solidity } from "ethereum-waffle";
import { DataTable, Then } from '@cucumber/cucumber';
import { World } from '../support';

chai.use(solidity);

Then(
    /^during the (\d+)(?=st|nd|rd|th) transaction the (.*) smart contract logs "(.*)" event"$/,
    async function (
        this: World,
        transactionId: number,
        contractId: string,
        eventName: string
    ) {
        throw new Error("Not implemented");
    }
)

Then(
    /^during the (\d+)(?=st|nd|rd|th) transaction the (.*) smart contract logs "(.*)" event with the parameters:"$/,
    async function (
        this: World,
        transactionId: number,
        contractId: string,
        eventName: string,
        dataTable: DataTable
    ) {
        throw new Error("Not implemented");
    }
)

Then(
    /^the failure reason is "(.*)"$/,
    async function (
        this: World,
        revertReason: string
    ) {
        const transaction = this.reproduceTransaction();

        await chai
            .expect(transaction)
            .to.be.revertedWith(revertReason);
    }
)

Then(
    /^the (.*) smart contract logs "(.*)" event"$/,
    async function (
        this: World,
        contractId: string,
        eventName: string
    ) {
        throw new Error("Not implemented");
    }
)

Then(
    /^the (.*) smart contract logs "(.*)" event with the parameters:"$/,
    async function (
        this: World,
        contractId: string,
        eventName: string,
        dataTable: DataTable
    ) {
        throw new Error("Not implemented");
    }
)

Then(
    /^the call result is true$/,
    async function (
        this: World
    ) {
        chai
            .expect(this.getCallResult())
            .to.be.true;
    }
)

Then(
    /^the call result is false$/,
    async function (
        this: World
    ) {
        chai
            .expect(this.getCallResult())
            .to.be.false;
    }
)

Then(
    /^the call result is equal to (.*)$/,
    async function (
        this: World,
        expectedValue: number
    ) {
        chai
            .expect(this.getCallResult())
            .to.equal(expectedValue);
    }
)

Then(
    /^the call result is the address of (.*)$/,
    async function (
        this: World,
        expectedAddress: string
    ) {
        chai
            .expect(this.getCallResult())
            .to.equal(await this.translateExpectedValue(`address of ${expectedAddress}`));
    }
)

Then(
    /^the transaction execution result is failure$/,
    async function (
        this: World
    ) {
        await chai
            .expect(this.reproduceTransaction())
            .to.be.reverted;
    }
)

Then(
    /^the transaction execution result is success$/,
    async function (
        this: World
    ) {
        const transaction = this.reproduceTransaction();

        await chai
            .expect(transaction)
            .not.be.reverted;
    }
)

Then(
    /^the (\d+)(?=st|nd|rd|th) call result is the address of (.*)$/,
    async function (
        this: World,
        callId: number,
        expectedAddress: string
    ) {
        throw new Error("Not implemented");
    }
)

Then(
    /^the (\d+)(?=st|nd|rd|th) transaction execution result is failure$/,
    async function (
        this: World,
        transactionId: number
    ) {
        await chai
            .expect(this.reproduceTransaction(transactionId))
            .to.be.reverted;
    }
)

Then(
    /^the (\d+)(?=st|nd|rd|th) transaction execution result is success$/,
    async function (
        this: World,
        transactionId: number
    ) {
        await chai
            .expect(this.reproduceTransaction(transactionId))
            .not.be.reverted;
    }
)