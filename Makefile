-include .env

.PHONY: all anvil clean deploy forge script cast chisel send call BasicNft MoodNft mintNft tokenURI help install format snapshot coverage

ANVIL_RPC_URL := http://127.0.0.1:8545
ANVIL_DEFAULT_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "		make deploy [ARGS...]\n		example make deploy ARGS=\"--network-sepolia\""

all: clean remove install update build

clean:; forge clean

remove:; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install:; forge install foundry-rs/forge-std@v1.5.3 --no-commit && forge install Cyfrin/foundry-devops@0.0.11 --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit

update:; forge update

build:; forge build

test:; forge test

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_DEFAULT_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

DeployBasicNft:
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft $(NETWORK_ARGS)

DeployMoodNft:
	@forge script script/DeployMoodNft.s.sol:DeployMoodNft $(NETWORK_ARGS)

mintBasicNft:
	@forge script script/Interactions.s.sol:MintBasicNft $(NETWORK_ARGS)

mintMoodNft:
	@forge script script/Interactions.s.sol:MintMoodNft $(NETWORK_ARGS)

flipMood:
	@forge script script/Interactions.s.sol:FlipMood $(NETWORK_ARGS)
