import { ethers } from 'hardhat';


export enum ActorName {
    Narrator,
    Alice,
    Bob,
    Charlie,
    Frank,
    Grace,
    Judy,
    Mallory,
    Olivia,
    Victor
}

export async function get(
    actorName?: string | ActorName
) {

    if (actorName === undefined) {
        actorName = ActorName.Narrator;
    } else if (typeof actorName === 'string' && isKnown(actorName)) {
        actorName = ActorName[actorName];
    }

    return (await ethers.getSigners())[actorName];
}

export function isKnown(
    actorName: string
) {
    // Integers are not valid actor names
    if (/\d+/.test(actorName)) {
        return false;
    }

    return actorName in ActorName;
}