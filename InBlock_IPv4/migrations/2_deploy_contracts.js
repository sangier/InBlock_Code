var InBlock_Data = artifacts.require("./InBlock_Data.sol");
var InBlock= artifacts.require("./InBlock.sol");
var InBlock_F = artifacts.require("./InBlock_F.sol");

module.exports = function(deployer) {
  deployer.deploy(InBlock_Data);
  deployer.deploy(InBlock_F);
  deployer.deploy(InBlock);
};
