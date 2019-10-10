package main

import (
	"github.com/herumi/bls-go-binary/src/bls"
	"testing"
)

func BenchmarkPairing(b *testing.B) {
	bls.Init(bls.BLS12_381)
	var P bls.G1
	var Q bls.G2
	var e bls.GT
	P.HashAndMapTo([]byte("abc"))
	Q.HashAndMapTo([]byte("abc"))
	for i := 0; i < b.N; i++ {
		bls.Pairing(&e, &P, &Q)
	}
}
