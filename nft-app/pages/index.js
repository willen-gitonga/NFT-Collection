import { Contract, providers, utils } from "ethers";
import Head from "next/head";
import React, { useEffect, useRef, useState } from "react";
import Web3Modal from "web3modal";
import { abi, NFT_CONTRACT_ADDRESS } from "../constants";
import styles from "../styles/Home.module.css";

export default function Home() {

  // walletConnected keep track of whether the user's wallet is connected or not
  const [walletConnected, setWalletConnected] = useState(false);
  const [presaleStarted, setPresaleStarted] = useState(false);
  const [presaleEnded, setPresaleEnded] = useState(false);
  // waiting for a transaction to get mined
  const [loading, setLoading] = useState(false);
  // checks if the currently connected MetaMask wallet is the owner of the contract
  const [isOwner, setIsOwner] = useState(false);
  // keep track of the number of tokenIds that have been minted
  const [tokenIdsMinted, setTokenIdsMinted] = useState("0");
  // Create a reference to the Web3 Modal for connecting to metamask
  const web3ModalRef = useRef();

  const presaleMint = async () => {
    try {
      //  Signer here since this is a 'write' transaction.
      const signer = await getProviderOrSigner(true);
      // instance of the Contract with a Signer
      const whitelistContract = new Contract(
        NFT_CONTRACT_ADDRESS,
        abi,
        signer
      );
      const tx = await whitelistContract.presaleMint({
        // value signifies the cost of one crypto dev which is "0.01" eth.
        // parsing `0.01` string to ether using the utils library from ethers.js
        value: utils.parseEther("0.01"),
      });
      setLoading(true);
      await tx.wait();
      setLoading(false);
      window.alert("You successfully minted a Crypto Dev!");
    }
    catch (err) {
      console.error(err);
    }
  };

}