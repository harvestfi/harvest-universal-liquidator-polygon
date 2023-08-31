# Harvest Universal Liquidator Polygon

This is the gateway for all Harvest strategies to execute swaps with multiple Dexes.

## Get Started

1.  Fill in the environment variables.

    ```bash
    cp .env.example .env
    ```

2.  Set up dependencies.

    ```bash
    yarn
    ```

## Prerequisites

- [Foundry](https://github.com/foundry-rs/foundry)

## Test locally

```bash
forge test -vvv
```

## Deploy

While deploying locally, set up the local node with `anvil`. Make sure that the address from the private key has enough gas to deploy or use one of the ten addresses with the `MNEMONIC` set up with `anvil`.

```bash
source .env
anvil -m $MNEMONIC
or
anvil -m $MNEMONIC --fork-url <RPC_URL>
```

Create a corresponding network section inside `deployed-addresses.json`.

```json
"<template-for-new-network>": {
"UniversalLiquidator": "",
"UniversalLiquidatorRegistry": "",
"UniV3Dex": "",
"BalancerDex": "",
"SushiswapDex": "",
"CurveDex": "",
"<new-address-item-to-store>": ""
},
```

Deploy contracts with corresponding scripts.

```bash
./script/_scripts.sh script/<SCRIPTS.s.sol>
```

---

There are 5 scripts to deploy:

- _script/SystemBase.s.sol_
- _script/Dex.s.sol_
- _script/Path.s.sol_
- _script/Pool.s.sol_
- _script/Fee.s.sol_

Executing each script will require a few configurations:

Determine the Network.

```bash
Which network do you want to deploy to?
Options: local, eth-mainnet, eth-sepolia, arb-mainnet, arb-goerli, polygon-mainnet, polygon-mumbai
```

Determine whether or not to broadcast, if the network is not local.

```bash
Broadcast? [y/n]...
```

Determine whether or not to verify, if the network is not local.

```bash
Verify contract? [y/n]...
```

Determine the profile to use.

```bash
Profile? [default/optimized]...
```

(With Dex.s.sol) Determine which Dex to deploy.

```bash
Which dex do you want to deploy? (Ex: UniV3Dex, the contract name)
```

(With Dex.s.sol) Determine the name for the Dex.

```bash
Which name do you want to represent the dex? (Ex: uniV3)
```

(With Path.s.sol, Pool.s.sol, or Fee.s.sol) Determine the config parameters file for setting up. There are three example files for reference: _Paths.0000.json_, _Pools.0000.json_, and _Fees.0000.json_.

```bash
Setup with which file? (Ex: Paths.0000.json)
```
