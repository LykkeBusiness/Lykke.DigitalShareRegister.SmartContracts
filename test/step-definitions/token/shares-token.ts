import { When } from '@cucumber/cucumber'
import { World } from '../../support'

const defaultContractId = 'shares token';
const contractDefinition = World.registerContractDefinition(defaultContractId, 'SharesToken');