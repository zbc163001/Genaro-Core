// Copyright 2016 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package vm

import (
	"math/big"

	"github.com/GenaroNetwork/Genaro-Core/common"
	"github.com/GenaroNetwork/Genaro-Core/core/types"
	"github.com/GenaroNetwork/Genaro-Core/common/hexutil"
)

// StateDB is an EVM database for full state querying.
type StateDB interface {
	CreateAccount(common.Address)

	SubBalance(common.Address, *big.Int)
	AddBalance(common.Address, *big.Int)
	GetBalance(common.Address) *big.Int

	GetNonce(common.Address) uint64
	SetNonce(common.Address, uint64)

	GetCodeHash(common.Address) common.Hash
	GetCode(common.Address) []byte
	SetCode(common.Address, []byte)
	GetCodeSize(common.Address) int

	AddRefund(uint64)
	GetRefund() uint64

	GetState(common.Address, common.Hash) common.Hash
	SetState(common.Address, common.Hash, common.Hash)

	Suicide(common.Address) bool
	HasSuicided(common.Address) bool

	// Exist reports whether the given account exists in state.
	// Notably this should also return true for suicided accounts.
	Exist(common.Address) bool
	// Empty returns whether the given account is empty. Empty
	// is defined according to EIP161 (balance = nonce = code = 0).
	Empty(common.Address) bool

	RevertToSnapshot(int)
	Snapshot() int

	AddLog(*types.Log)
	AddPreimage(common.Hash, []byte)

	ForEachStorage(common.Address, func(common.Hash, common.Hash) bool)

	UpdateHeft(common.Address, uint64) bool
	GetHeft(common.Address) (uint64, error)

	UpdateStake(common.Address, uint64) bool
	DeleteStake(common.Address, uint64) (bool, uint64)
	GetStake(common.Address) (uint64, error)

	UpdateBucketProperties(common.Address, string, uint64, uint64, uint64, uint64) bool
	GetStorageSize(common.Address, [32]byte)  (uint64, error)
	GetStorageGasPrice(common.Address, [32]byte)  (uint64, error)
	GetStorageGasUsed(common.Address, [32]byte)  (uint64, error)
	GetStorageGas(common.Address, [32]byte)  (uint64, error)
	SpecialTxTypeMortgageInit(common.Address,types.SpecialTxTypeMortgageInit) bool
	SpecialTxTypeSyncSidechainStatus(common.Address,types.SpecialTxTypeMortgageInit) (map[common.Address] *big.Int, bool)
	UpdateTraffic(common.Address, uint64) bool

	GetTraffic(common.Address)uint64

	GetBuckets(common.Address) (map[string]interface{}, error)

	//根据用户id和fileID,dataVersion获取交易日志
	TxLogByDataVersionRead(common.Address,[32]byte,string) (map[common.Address] *hexutil.Big, error)
	//根据用户id和fileID开启定时同步日志接口
	TxLogBydataVersionUpdate(common.Address,[32]byte) bool

	SyncStakeNode(common.Address, []string) error
	SyncNode2Address(common.Address, []string, string) error
	GetAddressByNode(string) string
	SynchronizeShareKey(common.Address,types.SynchronizeShareKey) bool

	UpdateFileSharePublicKey(common.Address, string) bool
	UnlockSharedKey(common.Address,string) bool
}

// CallContext provides a basic interface for the EVM calling conventions. The EVM EVM
// depends on this context being implemented for doing subcalls and initialising new EVM contracts.
type CallContext interface {
	// Call another contract
	Call(env *EVM, me ContractRef, addr common.Address, data []byte, gas, value *big.Int) ([]byte, error)
	// Take another's contract code and execute within our own context
	CallCode(env *EVM, me ContractRef, addr common.Address, data []byte, gas, value *big.Int) ([]byte, error)
	// Same as CallCode except sender and value is propagated from parent to child scope
	DelegateCall(env *EVM, me ContractRef, addr common.Address, data []byte, gas *big.Int) ([]byte, error)
	// Create a new contract
	Create(env *EVM, me ContractRef, data []byte, gas, value *big.Int) ([]byte, common.Address, error)
}
