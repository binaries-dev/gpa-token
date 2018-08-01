var GPA = artifacts.require("./GPA.sol");

module.exports = function(deployer, network) {
  if (network == "live") {
    deployer.deploy(GPA);
  } else {
    deployer.deploy(GPA);
  }
}
