package bls

import (
	"testing"
)

func InitForDFINITY() error {
	err := Init(BLS12_381)
	if err != nil {
		return err
	}
	// set Ethereum serialization format.
	SetETHserialization(true)
	err = SetMapToMode(IRTF)
	if err != nil {
		return err
	}
	// set the generator of G2. see https://www.ietf.org/archive/id/draft-irtf-cfrg-pairing-friendly-curves-11.html#section-4.2.1
	var gen PublicKey
	g2genStr := "1 0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8 0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e 0x0ce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801 0x0606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"
	err = gen.SetHexString(g2genStr)
	if err != nil {
		return err
	}
	err = SetGeneratorOfPublicKey(&gen)
	if err != nil {
		return err
	}
	dst := "BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_"
	err = SetDstG1(dst)
	if err != nil {
		return err
	}
	return nil
}

func TestDFINITY(t *testing.T) {
	if InitForDFINITY() != nil {
		t.Error("InitForDFINITY")
	}

	// test of https://github.com/dfinity/agent-js/blob/5214dc1fc4b9b41f023a88b1228f04d2f2536987/packages/bls-verify/src/index.test.ts#L101
	pubStr := "a7623a93cdb56c4d23d99c14216afaab3dfd6d4f9eb3db23d038280b6d5cb2caaee2a19dd92c9df7001dede23bf036bc0f33982dfb41e8fa9b8e96b5dc3e83d55ca4dd146c7eb2e8b6859cb5a5db815db86810b8d12cee1588b5dbf34a4dc9a5"
	sigStr := "b89e13a212c830586eaa9ad53946cd968718ebecc27eda849d9232673dcd4f440e8b5df39bf14a88048c15e16cbcaabe"
	var pub PublicKey
	var sig Sign
	if pub.DeserializeHexStr(pubStr) != nil {
		t.Error("pub.DeserializeHexStr")
	}
	if sig.DeserializeHexStr(sigStr) != nil {
		t.Error("sig.DeserializeHexStr")
	}
	if !sig.Verify(&pub, "hello") {
		t.Error("verify1")
	}
	if sig.Verify(&pub, "hallo") {
		t.Error("verify2")
	}
}
