# 🔄 UUPS Proxy Upgrade Demo

A minimal Foundry demo showing how to deploy and upgrade a **UUPS (EIP-1822)** proxy from **Implementation V1** to **Implementation V2**.

---

## 🧩 Overview

This project demonstrates:
- Deploying a UUPS proxy and an implementation contract (`V1`).
- Upgrading the proxy to a new implementation (`V2`).
- Preserving state across upgrades.

**Tech stack:**  
🧱 Solidity (≥0.8.19) • ⚙️ Foundry • 🧪 OpenZeppelin UUPSUpgradeable

---


---

## 🚀 Run locally

```bash
# Deps
forge install OpenZeppelin/openzeppelin-contracts-upgradeable
forge install Cyfrin/foundry-devops 
forge install openzeppelin/openzeppelin-contracts

