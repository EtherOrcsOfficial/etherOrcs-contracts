# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

install: solc update npm

# dapp deps
update:; dapp update

# npm deps for linting etc.
npm:; yarn install

# install solc version
# example to install other versions: `make solc 0_8_2`
SOLC_VERSION := 0_8_7
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_7

# Build & test
build  :; dapp build
test   :; dapp test # --rpc $ETH_RPC_URL --rpc-block 13531440 # --ffi # enable if you need the `ffi` cheat code on HEVM
testFork :; dapp test --rpc $ETH_RPC_URL --match testFork_
debug  :; dapp debug
clean  :; dapp clean
lint   :; yarn run lint
estimate :; ./scripts/estimate-gas.sh ${contract}
size   :; ./scripts/contract-size.sh ${contract}

# Deployment helpers
deploy :; @./scripts/deploy.sh

# mainnet
deploy-mainnet: export ETH_RPC_URL = $(call network,mainnet)
deploy-mainnet: check-api-key deploy

# rinkeby
deploy-rinkeby: export ETH_RPC_URL = $(call network,rinkeby)
deploy-rinkeby: check-api-key deploy

check-api-key:
ifndef ALCHEMY_API_KEY
	$(error ALCHEMY_API_KEY is undefined)
endif

# Returns the URL to deploy to a hosted node.
# Requires the ALCHEMY_API_KEY env var to be set.
# The first argument determines the network (mainnet / rinkeby / ropsten / kovan / goerli)
define network
	https://eth-$1.alchemyapi.io/v2/${ALCHEMY_API_KEY}
endef
