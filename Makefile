-include .env

build :; forge build
deploy-sepolia :; forge script ./script/DeployAirdrop.s.sol:DeployAirdrop --rpc-url $(SEPOLIA_RPC_URL) --keystore $(KEYSTORE_PATH_SEPOLIA) --broadcast --verify --etherscan-api-key $(ETHERSCAN_TOKEN)
deploy-anvil :; forge script DeployAirdrop --rpc-url $(RPC_URL) --keystore $(KEYSTORE_PATH) --broadcast
install :; forge install
