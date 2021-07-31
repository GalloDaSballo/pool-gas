/* eslint-disable func-names */
import { expect } from "chai";
import { deployments, ethers } from "hardhat";
import { SwappableYieldSource } from "../typechain";
import { deploy, deployMock } from "./helpers";

const USER = "0xB08b352Ea173F4E855dfeb4d0Fd079aE53A1B3c5";

const setup = deployments.createFixture(async () => {
    const admin = await ethers.getNamedSigner("deployer");
    const erc20 = await deploy("ERC20Upgradeable", { connect: admin });
    const contract = await deploy<SwappableYieldSource>("SwappableYieldSource", {
        connect: admin,
        args: [erc20.address],
    });

    return {
        contract,
    };
});

describe("Unit tests", function () {
    describe("LoopArrayRemoval", function () {
        let contract: SwappableYieldSource;
        beforeEach(async function () {
            const deployment = await setup();
            contract = deployment.contract;
            // Contract is deployed before each, setting allowance to non zero
        });

        it("Max Allowance with sub math", async function () {
            await (await contract.approveMaxAmount()).wait();
        });

        it("Max allowance via zero and max", async function () {
            await (await contract.approveMaxAmountWithReset()).wait();
        });
    });
});
