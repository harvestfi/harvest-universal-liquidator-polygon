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

## Registry maintenance

The `UniversalLiquidatorRegistry` emits no events and its `paths` mapping has no
enumerator, so the configured routes cannot be listed from the chain directly.
`tools/registry.json` is the checked-in record of what the registry is *supposed* to
contain; the tooling diffs it against what is actually deployed.

```shell
yarn registry:audit                  # 1. is the chain what the manifest says?
yarn registry:routes                 # 2. find better routes -> proposals file
#                                      3. review that file
yarn registry:apply                  # 4. dry run: see the transactions
APPLY_EXECUTE=1 yarn registry:apply  # 5. send them (updates the manifest)
yarn registry:audit                  # 6. confirm
```

**Set `REGISTRY_RPC_URL` first**, in `.env` or inline:

```shell
REGISTRY_RPC_URL=https://polygon-bor-rpc.publicnode.com
```

To send transactions, also set `REGISTRY_PRIVATE_KEY` (or `MNEMONIC`). The signer
must be the registry owner; the scripts refuse otherwise.

`registry:seed` rebuilds the manifest from the chain, needed only when paths were
changed outside this tooling. `registry:sync` is the opposite direction, for when
the manifest is edited by hand and the chain has to catch up.

### What the audit checks

Errors (exit code 1): the UL points at this registry; every dex resolves to the
manifest address and none to `address(0)`; intermediate tokens match **in order**
(`getPath` returns the first match, so order decides routing); every manifest path
exists on chain with the same dex and token array, and no chain path is missing
from the manifest; every hop resolves to a pool that is actually deployed; and
no concentrated-liquidity hop sits on a pool with zero active liquidity. That
last one can hold plenty of both tokens while every position is out of range,
and it reverts on any swap — a `doHardWork` that reverts, not a bad price.

Warnings: a hop's pool below its `minLiquidity` floor, a pair with no reverse
path, a UniV3 hop on the default fee (indistinguishable from unset), and any dex
whose `kind` is `unknown`.

### Proposing better routes

`registry:routes` quotes every registered route against alternatives on the other
dexes and writes what it finds to the proposals file. Test swaps are sized in
**dollars** (`PROPOSE_USD`, default 1000) because that is the size a liquidation
actually is. There is no price feed: each sell token is priced by quoting a
sliver of its deepest pool into `usdAnchor`.

`registry:apply` turns those back into transactions, re-quoting every proposal
first because prices move. A proposal is more than a `setPath`: the dex needs the
pair config the quote was taken with, so the `setFee` / `setTickSpacing` /
`pairSetup` calls are emitted before it.

A registered route that does not quote at all is treated as broken rather than
merely worse: there is no percentage to compare, so any alternative that does
quote is proposed for it. That is what catches a pool that has drained or whose
liquidity has moved out of range.

A pair with nothing registered has no route to compare against, so it has to be
asked for. `PROPOSE_NEW_PAIRS` takes `SELL>BUY` entries (`->` works too),
comma, space or newline separated, inline or in a file, and either side may be
an address or a symbol the manifest already names. `PROPOSE_NEW_TOKENS` is the
shorthand for a new reward token: one address expands to that token against
every intermediate, which is all the registry needs.

```shell
PROPOSE_NEW_PAIRS="0xAbC…>cbBTC, WETH -> 0xDeF…" yarn registry:routes
PROPOSE_NEW_PAIRS=wanted.txt yarn registry:routes
PROPOSE_NEW_TOKENS=0xAbC… yarn registry:routes
```

A pair with no entry of its own may still be reachable: `getPath` falls back to
the first intermediate token with a path on both sides and swaps in two legs,
and since each leg is itself multi-hop, that can cross more pools than any one
entry. The proposer reads what the registry does today and weighs a direct entry
against it, reporting rather than proposing one that would not improve on it
(the per-leg shares are multiplied, so it is approximate).

Candidates are quoted exactly as for a registered pair; what differs is the
accept test. With no incumbent to beat, a route is judged on value kept: it has
to retain `PROPOSE_MIN_RETENTION` (default 90%) of the input, because an
illiquid token quotes something through almost any pool and a route that gives
up half the value is worse than having none. A pair that *is* registered is
compared the ordinary way instead. `registry:apply` sends these like any other
proposal and adds the tokens and paths to the manifest.

Dexes marked `kind: "unknown"` on Polygon are skipped by both the hop checks and
the proposer — they do not fit any resolution shape the tooling knows.
