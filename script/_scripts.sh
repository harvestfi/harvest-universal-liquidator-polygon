#!/usr/bin/env bash

if [ -f .env ]
then
  source .env
else
  echo "Please set your .env file"
  exit 1
fi

if [ "$1" = "script/Dex.s.sol" ]; 
then
  echo "Which dex do you want to deploy? (Ex: UniV3Dex, the contract name)"
  read dex
  echo ""

  echo "Which name do you want to represent the dex? (Ex: uniV3)"
  read dex_name
  echo ""

  ADD_ENVS="DEX=$dex DEX_NAME=$dex_name"
fi

if [ "$1" = "script/Path.s.sol" ] || [ "$1" = "script/Pool.s.sol" ] || [ "$1" = "script/Fee.s.sol" ];
then
  echo "Setup with which file?"
  read file
  echo ""

  ADD_ENVS="SETUP_FILE=$file"
fi

echo "Which network do you want to deploy to?"
echo "Options: local, eth-mainnet, eth-sepolia, arb-mainnet, arb-goerli, polygon-mainnet, polygon-mumbai"
read network
echo ""

if [ "$network" != "local" ]; 
then
  ARGS="--rpc-url https://$network.g.alchemy.com/v2/$ALCHEMEY_KEY"

  echo "Broadcast? [y/n]..."
  read broadcast
  echo ""

  if [ "$broadcast" = "y" ]
  then
    ARGS="$ARGS --broadcast"
  fi

  echo "Verify contract? [y/n]..."
  read verify
  echo ""

  if [ "$verify" = "y" ]
  then
    ARGS="$ARGS --verify"
  fi

  echo "Gas Estimate Multiplier? (Default 130)..."
  read gas_multiplier
  echo ""

  if [ "$gas_multiplier" = "" ]
  then 
    gas_multiplier=130
  fi

  ARGS="$ARGS --gas-estimate-multiplier $gas_multiplier"
    
else
  ARGS="--fork-url http://localhost:8545 --broadcast"
fi

ADD_ENVS="$ADD_ENVS NETWORK=$network"
ARGS="$ARGS --private-key $PRIVATE_KEY"

echo "Profile? [default/optimized]..."
read profile

if [ "$profile" = "default" ] || [ "$profile" = "optimized" ]; 
then
  export FOUNDRY_PROFILE=$profile
  echo ""
  echo "Using profile: $FOUNDRY_PROFILE"
  echo ""
else
  echo ""
  echo "Invalid profile! 🛑🛑🛑"
  exit 0
fi

echo "Running script: $1"
echo "Arguments: $ARGS"
echo "Additional envs: $ADD_ENVS"

if [ "$ADD_ENVS" != "" ]; then
  echo "Adding envs..."
  export $ADD_ENVS
fi

forge script $1 $ARGS

if [ "$1" = "script/Dex.s.sol" ]; 
then
  unset "DEX DEX_NAME"
fi

if [ "$1" = "script/Path.s.sol" ] || [ "$1" = "script/Pool.s.sol" ] || [ "$1" = "script/Fee.s.sol" ];
then
  unset "SETUP_FILE"
fi

unset "NETWORK"

echo "Script ran successfully 🎉🎉🎉"