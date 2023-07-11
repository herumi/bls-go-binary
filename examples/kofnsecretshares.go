package main

import (
	"fmt"
	"strconv"

	"github.com/herumi/bls-go-binary/bls"
)

func MessageSign() {
	bls.Init(bls.BLS12_381)
	sk := bls.SecretKey{}

	sk.SetByCSPRNG()

	pk := sk.GetPublicKey()

	fmt.Println("secret key is: ", sk.GetHexString())

	fmt.Println("public key is: ", sk.GetPublicKey().GetHexString())

	message := "hello"

	signature := sk.Sign(message)

	fmt.Println("is verified, ", signature.Verify(pk, message))
}

func SecretShare() {
	bls.Init(bls.BLS12_381)

	n := 5
	k := 3

	ids := make([]*bls.ID, n)
	secs := make([]bls.SecretKey, n)
	publs := make([]*bls.PublicKey, n)
	sigs := make([]*bls.Sign, n)

	msk := make([]bls.SecretKey, k)

	for i := 0; i < k; i++ {
		msk[i].SetByCSPRNG()
	}

	// share the secret key(s)
	for i := 0; i < n; i++ {
		ids[i] = &bls.ID{}
		ids[i].SetHexString("0x" + strconv.FormatInt(int64(i+1), 16))
	}

	for i := 0; i < n; i++ {
		secs[i].Set(msk, ids[i])
	}

	mpk := bls.GetMasterPublicKey(msk)
	// fmt.Println("master public key:", mpk)

	// for each users

	for i := 0; i < n; i++ {
		publs[i] = secs[i].GetPublicKey()
	}

	// each user signs the message

	msg := "Hello"

	for i := 0; i < n; i++ {
		sigs[i] = secs[i].Sign(msg)
	}


	subSigs := make([]bls.Sign, k)
	subIds := make([]bls.ID, k)
	for i := 0; i < n; i++ {
		subSigs[0] = *sigs[i]
		subIds[0] = *ids[i]
		for j := i + 1; j < n; j++ {
			subSigs[1] = *sigs[j]
			subIds[1] = *ids[j]
			for k := j + 1; k < n; k++ {
				subSigs[2] = *sigs[k]
				subIds[2] = *ids[k]
				// recover sig from subSigs[K] and subIds[K]
				sig := &bls.Sign{}

				err := sig.Recover(subSigs, subIds)
				if err != nil {
					fmt.Println(err)
					return
				}
				isVerified := sig.Verify(&mpk[0], msg)
				if !isVerified {
					return
				}
				fmt.Println("signature verified")
			}
		}
	}

}

func main() {
	SecretShare()
}