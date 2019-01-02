var InBlock_Data = artifacts.require("./InBlock_Data.sol");
var InBlock= artifacts.require("./InBlock.sol");
var InBlock_F = artifacts.require("./InBlock_F.sol");
var InBlock_F_del = artifacts.require("./InBlock_F_del.sol");
var Utility = artifacts.require("./Utility.sol");

module.exports = function(deployer) {
  deployer.deploy(InBlock_Data);
  deployer.deploy(Utility);
  deployer.deploy(InBlock_F);
  deployer.deploy(InBlock_F_del);
  deployer.deploy(InBlock);
};
