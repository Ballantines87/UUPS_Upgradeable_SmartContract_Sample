-include .env

.PHONY: all build test

build: 
	forge build

test:
	forge test -vvvv

