/* eslint-disable func-names */
import { expect } from "chai";
import { deployments, ethers } from "hardhat";
import { LoopArrayRemoval } from "../typechain";
import { deploy } from "./helpers";

const USER = "0xB08b352Ea173F4E855dfeb4d0Fd079aE53A1B3c5";

const setup = deployments.createFixture(async () => {
    const admin = await ethers.getNamedSigner("admin");
    const contract = await deploy<LoopArrayRemoval>("LoopArrayRemoval", { connect: admin });

    return {
        contract,
    };
});

describe("Unit tests", function () {
    describe("LoopArrayRemoval", function () {
        let contract: LoopArrayRemoval;
        beforeEach(async function () {
            const deployment = await setup();
            contract = deployment.contract;
            // Add some stuff here
            await (await contract.add(USER, 0)).wait();
            await (await contract.add(USER, 1)).wait();
            await (await contract.add(USER, 2)).wait();
            await (await contract.add(USER, 3)).wait();
            await (await contract.add(USER, 4)).wait();
            await (await contract.add(USER, 5)).wait();
        });

        it("Remove with current solution", async function () {
            await (await contract.removeUserActiveBlocks(USER, 0)).wait();
            await (await contract.removeUserActiveBlocks(USER, 1)).wait();
            await (await contract.removeUserActiveBlocks(USER, 2)).wait();
            await (await contract.removeUserActiveBlocks(USER, 3)).wait();
            await (await contract.removeUserActiveBlocks(USER, 4)).wait();
            await (await contract.removeUserActiveBlocks(USER, 5)).wait();
        });

        it("Remove via loop", async function () {
            await (await contract.remove(USER, 0)).wait();
            await (await contract.remove(USER, 1)).wait();
            await (await contract.remove(USER, 2)).wait();
            await (await contract.remove(USER, 3)).wait();
            await (await contract.remove(USER, 4)).wait();
            await (await contract.remove(USER, 5)).wait();
        });
    });
});
