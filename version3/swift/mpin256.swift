/*
	Licensed to the Apache Software Foundation (ASF) under one
	or more contributor license agreements.  See the NOTICE file
	distributed with this work for additional information
	regarding copyright ownership.  The ASF licenses this file
	to you under the Apache License, Version 2.0 (the
	"License"); you may not use this file except in compliance
	with the License.  You may obtain a copy of the License at
	
	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing,
	software distributed under the License is distributed on an
	"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
	KIND, either express or implied.  See the License for the
	specific language governing permissions and limitations
	under the License.
*/

//
//  mpin256.swift
//
//  Created by Michael Scott on 08/07/2015.
//  Copyright (c) 2015 Michael Scott. All rights reserved.
//

import Foundation
import amcl

final public class MPIN256
{
    static public let EFS=Int(BIG.MODBYTES)
    static public let EGS=Int(BIG.MODBYTES)
    //static public let PAS:Int=16
    static let INVALID_POINT:Int = -14
    static let BAD_PARAMS:Int = -11
    static let WRONG_ORDER:Int = -18
    static public let BAD_PIN:Int = -19
    static public let SHA256=32
    static public let SHA384=48
    static public let SHA512=64
    
    /* Configure your PIN here */
    
    static let MAXPIN:Int32 = 10000  // PIN less than this
    static let PBLEN:Int32 = 14      // Number of bits in PIN
    static let TS:Int = 10         // 10 for 4 digit PIN, 14 for 6-digit PIN - 2^TS/TS approx = sqrt(MAXPIN)
    static let TRAP:Int = 200      // 200 for 4 digit PIN, 2000 for 6-digit PIN  - approx 2*sqrt(MAXPIN)

   
    private static func mpin_hash(_ sha:Int,_ c: FP16,_ U: ECP) -> [UInt8]
    {
        var w=[UInt8](repeating: 0,count: EFS)
        var t=[UInt8](repeating: 0,count: 18*EFS)
        var h=[UInt8]()
        
        c.geta().geta().geta().getA().toBytes(&w); for i in 0 ..< EFS {t[i]=w[i]}
        c.geta().geta().geta().getB().toBytes(&w); for i in EFS ..< 2*EFS {t[i]=w[i-EFS]}
        c.geta().geta().getb().getA().toBytes(&w); for i in 2*EFS ..< 3*EFS {t[i]=w[i-2*EFS]}
        c.geta().geta().getb().getB().toBytes(&w); for i in 3*EFS ..< 4*EFS {t[i]=w[i-3*EFS]}

        c.geta().getb().geta().getA().toBytes(&w); for i in 4*EFS ..< 5*EFS {t[i]=w[i-4*EFS]}
        c.geta().getb().geta().getB().toBytes(&w); for i in 5*EFS ..< 6*EFS {t[i]=w[i-5*EFS]}
        c.geta().getb().getb().getA().toBytes(&w); for i in 6*EFS ..< 7*EFS {t[i]=w[i-6*EFS]}
        c.geta().getb().getb().getB().toBytes(&w); for i in 7*EFS ..< 8*EFS {t[i]=w[i-7*EFS]}

        c.getb().geta().geta().getA().toBytes(&w); for i in 8*EFS ..< 9*EFS {t[i]=w[i-8*EFS]}
        c.getb().geta().geta().getB().toBytes(&w); for i in 9*EFS ..< 10*EFS {t[i]=w[i-9*EFS]}
        c.getb().geta().getb().getA().toBytes(&w); for i in 10*EFS ..< 11*EFS {t[i]=w[i-10*EFS]}
        c.getb().geta().getb().getB().toBytes(&w); for i in 11*EFS ..< 12*EFS {t[i]=w[i-11*EFS]}

        c.getb().getb().geta().getA().toBytes(&w); for i in 12*EFS ..< 13*EFS {t[i]=w[i-12*EFS]}
        c.getb().getb().geta().getB().toBytes(&w); for i in 13*EFS ..< 14*EFS {t[i]=w[i-13*EFS]}
        c.getb().getb().getb().getA().toBytes(&w); for i in 14*EFS ..< 15*EFS {t[i]=w[i-14*EFS]}
        c.getb().getb().getb().getB().toBytes(&w); for i in 15*EFS ..< 16*EFS {t[i]=w[i-15*EFS]}



        U.getX().toBytes(&w); for i in 16*EFS ..< 17*EFS {t[i]=w[i-16*EFS]}
        U.getY().toBytes(&w); for i in 17*EFS ..< 18*EFS {t[i]=w[i-17*EFS]}
        
        if sha==SHA256
        {
            let H=HASH256()
            H.process_array(t)
            h=H.hash()
        }
        if sha==SHA384
        {
            let H=HASH384()
            H.process_array(t)
            h=H.hash()
        }
        if sha==SHA512
        {
            let H=HASH512()
            H.process_array(t)
            h=H.hash()
        }
        if h.isEmpty {return h}
        var R=[UInt8](repeating: 0,count: ECP.AESKEY)
        for i in 0 ..< ECP.AESKEY {R[i]=h[i]}
        return R
    }
    
    // Hash number (optional) and string to point on curve
    
    private static func hashit(_ sha:Int,_ n:Int32,_ ID:[UInt8]) -> [UInt8]
    {
        var R=[UInt8]()
        if sha==SHA256
        {
            let H=HASH256()
            if n != 0 {H.process_num(n)}
            H.process_array(ID)
            R=H.hash()
        }
        if sha==SHA384
        {
            let H=HASH384()
            if n != 0 {H.process_num(n)}
            H.process_array(ID)
            R=H.hash()
        }
        if sha==SHA512
        {
            let H=HASH512()
            if n != 0 {H.process_num(n)}
            H.process_array(ID)
            R=H.hash()
        }
        if R.isEmpty {return R}
        let RM=Int(BIG.MODBYTES)
        var W=[UInt8](repeating: 0,count: RM)
        if sha >= RM
        {
            for i in 0 ..< RM {W[i]=R[i]}
        }
        else
        {
        for i in 0 ..< sha {W[i+RM-sha]=R[i]}

            //for i in 0 ..< sha {W[i]=R[i]}
        }
        return W
    }
    
    
    // return time in slots since epoch
    static public func today() -> Int32
    {
        let date=Date()
        return (Int32(date.timeIntervalSince1970/(60*1440)))
    }

    // these next two functions help to implement elligator squared - http://eprint.iacr.org/2014/043
    // maps a random u to a point on the curve
    static func map(_ u:BIG,_ cb:Int) -> ECP
    {
        let x=BIG(u)
        let p=BIG(ROM.Modulus)
        x.mod(p)
        var P=ECP(x,cb)
        while (true)
        {
            if !P.is_infinity() {break}
            x.inc(1);  x.norm()
            P=ECP(x,cb)
        }
        return P
    }

    // returns u derived from P. Random value in range 1 to return value should then be added to u
    static func unmap(_ u:inout BIG,_ P:ECP) -> Int
    {
        let s=P.getS()
        var r:Int32=0
        let x=P.getX()
        u.copy(x)
        var R=ECP()
        while (true)
        {
            u.dec(1); u.norm()
            r += 1
            R=ECP(u,s)
            if !R.is_infinity() {break}
        }
        return Int(r)
    }
    
    static public func HASH_ID(_ sha:Int,_ ID:[UInt8]) -> [UInt8]
    {
        return hashit(sha,0,ID)
    }
    
    // these next two functions implement elligator squared - http://eprint.iacr.org/2014/043
    // Elliptic curve point E in format (0x04,x,y} is converted to form {0x0-,u,v}
    // Note that u and v are indistinguisible from random strings
    static public func ENCODING(_ rng:RAND,_ E:inout [UInt8]) -> Int
    {
        var T=[UInt8](repeating: 0,count: EFS)
    
        for i in 0 ..< EFS {T[i]=E[i+1]}
        var u=BIG.fromBytes(T);
        for i in 0 ..< EFS {T[i]=E[i+EFS+1]}
        var v=BIG.fromBytes(T)
    
        let P=ECP(u,v);
        if P.is_infinity() {return INVALID_POINT}
    
        let p=BIG(ROM.Modulus)
        u=BIG.randomnum(p,rng)
    
        var su=rng.getByte();
        su%=2
    
        let W=MPIN256.map(u,Int(su))
        P.sub(W);
        let sv=P.getS();
        let rn=MPIN256.unmap(&v,P)
        let m=rng.getByte();
        let incr=1+Int(m)%rn
        v.inc(incr)
        E[0]=(su+UInt8(2*sv))
        u.toBytes(&T)
        for i in 0 ..< EFS {E[i+1]=T[i]}
        v.toBytes(&T)
        for i in 0 ..< EFS {E[i+EFS+1]=T[i]}
    
        return 0;
    }

    static public func DECODING(_ D:inout [UInt8]) -> Int
    {
        var T=[UInt8](repeating: 0,count: EFS)
    
        if (D[0]&0x04) != 0 {return INVALID_POINT}
    
        for i in 0 ..< EFS {T[i]=D[i+1]}
        var u=BIG.fromBytes(T)
        for i in 0 ..< EFS {T[i]=D[i+EFS+1]}
        var v=BIG.fromBytes(T)
    
        let su=D[0]&1
        let sv=(D[0]>>1)&1
        let W=map(u,Int(su))
        let P=map(v,Int(sv))
        P.add(W)
        u=P.getX()
        v=P.getY()
        D[0]=0x04
        u.toBytes(&T);
        for i in 0 ..< EFS {D[i+1]=T[i]}
        v.toBytes(&T)
        for i in 0 ..< EFS {D[i+EFS+1]=T[i]}
    
        return 0
    }
    // R=R1+R2 in group G1
    static public func RECOMBINE_G1(_ R1:[UInt8],_ R2:[UInt8],_ R:inout [UInt8]) -> Int
    {
        let P=ECP.fromBytes(R1)
        let Q=ECP.fromBytes(R2)
    
        if P.is_infinity() || Q.is_infinity() {return INVALID_POINT}
    
        P.add(Q)
    
        P.toBytes(&R)
        return 0;
    }
    // W=W1+W2 in group G2
    static public func RECOMBINE_G2(_ W1:[UInt8],_ W2:[UInt8],_  W:inout [UInt8]) -> Int
    {
        let P=ECP8.fromBytes(W1)
        let Q=ECP8.fromBytes(W2)
    
        if P.is_infinity() || Q.is_infinity() {return INVALID_POINT}
    
        P.add(Q)
        
        P.toBytes(&W)
        return 0
    }
    // create random secret S
    static public func RANDOM_GENERATE(_ rng:RAND,_ S:inout [UInt8]) -> Int
    {
        let r=BIG(ROM.CURVE_Order)
        let s=BIG.randomnum(r,rng)
    //if ROM.AES_S>0
    //{
    //  s.mod2m(2*ROM.AES_S)
    //}    
        s.toBytes(&S);
        return 0;
    }

    // Extract PIN from TOKEN for identity CID
    static public func EXTRACT_PIN(_ sha:Int,_ CID:[UInt8],_ pin:Int32,_ TOKEN:inout [UInt8]) -> Int
    {
        return MPIN256.EXTRACT_FACTOR(sha,CID,pin%MAXPIN,PBLEN,&TOKEN)
    }

    // Extract factor from TOKEN for identity CID
    static public func EXTRACT_FACTOR(_ sha:Int,_ CID:[UInt8],_ factor:Int32,_ facbits:Int32,_ TOKEN:inout [UInt8]) -> Int
    {
        let P=ECP.fromBytes(TOKEN)
        if P.is_infinity() {return INVALID_POINT}
        let h=MPIN256.hashit(sha,0,CID)
        var R=ECP.mapit(h)

        R=R.pinmul(factor,facbits)
        P.sub(R)
    
        P.toBytes(&TOKEN)
    
        return 0
    }    

    // ERestore factor to TOKEN for identity CID
    static public func RESTORE_FACTOR(_ sha:Int,_ CID:[UInt8],_ factor:Int32,_ facbits:Int32,_ TOKEN:inout [UInt8]) -> Int
    {
        let P=ECP.fromBytes(TOKEN)
        if P.is_infinity() {return INVALID_POINT}
        let h=MPIN256.hashit(sha,0,CID)
        var R=ECP.mapit(h)

        R=R.pinmul(factor,facbits)
        P.add(R)
    
        P.toBytes(&TOKEN)
    
        return 0
    }    

    // Extract PIN from TOKEN for identity CID
    /*
    static public func EXTRACT_PIN(_ sha:Int,_ CID:[UInt8],_ pin:Int32,_ TOKEN:inout [UInt8]) -> Int
    {
        let P=ECP.fromBytes(TOKEN)
        if P.is_infinity() {return INVALID_POINT}
        let h=MPIN256.hashit(sha,0,CID)
        var R=ECP.mapit(h)

        R=R.pinmul(pin%MAXPIN,MPIN256.PBLEN)
        P.sub(R)
    
        P.toBytes(&TOKEN)
    
        return 0
    }*/


    // Implement step 2 on client side of MPin protocol
    static public func CLIENT_2(_ X:[UInt8],_ Y:[UInt8],_ SEC:inout [UInt8]) -> Int
    {
        let r=BIG(ROM.CURVE_Order)
        var P=ECP.fromBytes(SEC)
        if P.is_infinity() {return INVALID_POINT}
    
        let px=BIG.fromBytes(X)
        let py=BIG.fromBytes(Y)
        px.add(py)
        px.mod(r)
     //   px.rsub(r)

        P=PAIR256.G1mul(P,px)
        P.neg()
        P.toBytes(&SEC);
      //  PAIR256.G1mul(P,px).toBytes(&SEC)
        return 0
    }
    
    // Implement step 1 on client side of MPin protocol
    static public func CLIENT_1(_ sha:Int,_ date:Int32,_ CLIENT_ID:[UInt8],_ rng:RAND?,_ X:inout [UInt8],_ pin:Int32,_ TOKEN:[UInt8],_ SEC:inout [UInt8],_ xID:inout [UInt8]?,_ xCID:inout [UInt8]?,_ PERMIT:[UInt8]?) -> Int
    {

        let r=BIG(ROM.CURVE_Order)
   //     let q=BIG(ROM.Modulus)
        var x:BIG
        if rng != nil
        {
            x=BIG.randomnum(r,rng!)
            //if ROM.AES_S>0
            //{
             //   x.mod2m(2*ROM.AES_S)
            //}
            x.toBytes(&X);
        }
        else
        {
            x=BIG.fromBytes(X);
        }
    //    var t=[UInt8](count:EFS,repeatedValue:0)

        var h=MPIN256.hashit(sha,0,CLIENT_ID)
        var P=ECP.mapit(h);
    
        let T=ECP.fromBytes(TOKEN);
        if T.is_infinity() {return INVALID_POINT}
    
        var W=P.pinmul(pin%MPIN256.MAXPIN,MPIN256.PBLEN)
        T.add(W)
        if date != 0
        {
            W=ECP.fromBytes(PERMIT!)
            if W.is_infinity() {return INVALID_POINT}
            T.add(W);
            h=MPIN256.hashit(sha,date,h)
            W=ECP.mapit(h);
            if xID != nil
            {
                P=PAIR256.G1mul(P,x)
                P.toBytes(&xID!)
                W=PAIR256.G1mul(W,x)
                P.add(W)
            }
            else
            {
                P.add(W);
                P=PAIR256.G1mul(P,x);
            }
            if xCID != nil {P.toBytes(&xCID!)}
        }
        else
        {
            if xID != nil
            {
                P=PAIR256.G1mul(P,x)
                P.toBytes(&xID!)
            }
        }
    
    
        T.toBytes(&SEC);
        return 0;
    }
    // Extract Server Secret SST=S*Q where Q is fixed generator in G2 and S is master secret
    static public func GET_SERVER_SECRET(_ S:[UInt8],_ SST:inout [UInt8]) -> Int
    {
        var Q=ECP8.generator();
    
        let s=BIG.fromBytes(S)
        Q=PAIR256.G2mul(Q,s)
        Q.toBytes(&SST)
        return 0
    }
 
    
    //W=x*H(G);
    //if RNG == NULL then X is passed in
    //if RNG != NULL the X is passed out
    //if type=0 W=x*G where G is point on the curve, else W=x*M(G), where M(G) is mapping of octet G to point on the curve
    
    static public func GET_G1_MULTIPLE(_ rng:RAND?,_ type:Int,_ X:inout [UInt8],_ G:[UInt8],_ W:inout [UInt8]) -> Int
    {
        var x:BIG
        let r=BIG(ROM.CURVE_Order)
        if rng != nil
        {
            x=BIG.randomnum(r,rng!)
            //if ROM.AES_S>0
            //{
            //    x.mod2m(2*ROM.AES_S)
            //}
            x.toBytes(&X)
        }
        else
        {
            x=BIG.fromBytes(X);
        }
        var P:ECP
        if type==0
        {
            P=ECP.fromBytes(G)
            if P.is_infinity() {return INVALID_POINT}
        }
        else
            {P=ECP.mapit(G)}
    
        PAIR256.G1mul(P,x).toBytes(&W)
        return 0;
    }
    // Client secret CST=S*H(CID) where CID is client ID and S is master secret
    // CID is hashed externally
    static public func GET_CLIENT_SECRET(_ S:inout [UInt8],_ CID:[UInt8],_ CST:inout [UInt8]) -> Int
    {
        return GET_G1_MULTIPLE(nil,1,&S,CID,&CST)
    }
    // Time Permit CTT=S*(date|H(CID)) where S is master secret
    static public func GET_CLIENT_PERMIT(_ sha:Int,_ date:Int32,_ S:[UInt8],_ CID:[UInt8],_ CTT:inout [UInt8]) -> Int
    {
        let h=MPIN256.hashit(sha,date,CID)
        let P=ECP.mapit(h)
    
        let s=BIG.fromBytes(S)
        PAIR256.G1mul(P,s).toBytes(&CTT)
        return 0;
    }
  
    // Outputs H(CID) and H(T|H(CID)) for time permits. If no time permits set HID=HTID
    static public func SERVER_1(_ sha:Int,_ date:Int32,_ CID:[UInt8],_ HID:inout [UInt8],_ HTID:inout [UInt8]?)
    {
        var h=MPIN256.hashit(sha,0,CID)
        let P=ECP.mapit(h)

    P.toBytes(&HID)
        if date != 0
        {
       //     if HID != nil {P.toBytes(&HID!)}
            h=hashit(sha,date,h)
            let R=ECP.mapit(h)
            P.add(R)
            P.toBytes(&HTID!)
        }
        //else {P.toBytes(&HID!)}
    }
    // Implement step 2 of MPin protocol on server side
    static public func SERVER_2(_ date:Int32,_ HID:[UInt8]?,_ HTID:[UInt8]?,_ Y:[UInt8],_ SST:[UInt8],_ xID:[UInt8]?,_ xCID:[UInt8]?,_ mSEC:[UInt8],_ E:inout [UInt8]?,_ F:inout [UInt8]?) -> Int
    { 
      //  _=BIG(ROM.Modulus);
        let Q=ECP8.generator();
        let sQ=ECP8.fromBytes(SST)
        if sQ.is_infinity() {return INVALID_POINT}
        var R:ECP
        if date != 0
            {R=ECP.fromBytes(xCID!)}
        else
        {
            if xID==nil {return MPIN256.BAD_PARAMS}
            R=ECP.fromBytes(xID!)
        }
        if R.is_infinity() {return INVALID_POINT}
        let y=BIG.fromBytes(Y)
        var P:ECP
        if date != 0 {P=ECP.fromBytes(HTID!)}
        else
        {
            if HID==nil {return MPIN256.BAD_PARAMS}
            P=ECP.fromBytes(HID!)
        }
    
        if P.is_infinity() {return INVALID_POINT}
    
        P=PAIR256.G1mul(P,y)
        P.add(R); P.affine()
        R=ECP.fromBytes(mSEC)
        if R.is_infinity() {return MPIN256.INVALID_POINT}

    
        var g=PAIR256.ate2(Q,R,sQ,P)
        g=PAIR256.fexp(g)
    
        if !g.isunity()
        {
            if HID != nil && xID != nil && E != nil && F != nil
            {
                g.toBytes(&E!)
                if date != 0
                {
                    P=ECP.fromBytes(HID!)
                    if P.is_infinity() {return MPIN256.INVALID_POINT}
                    R=ECP.fromBytes(xID!)
                    if R.is_infinity() {return MPIN256.INVALID_POINT}
    
                    P=PAIR256.G1mul(P,y);
                    P.add(R); P.affine()
                }
                g=PAIR256.ate(Q,P);
                g=PAIR256.fexp(g);
                g.toBytes(&F!);
            }
            return MPIN256.BAD_PIN;
        }
    
        return 0
    }
    // Pollards kangaroos used to return PIN error
    static public func KANGAROO(_ E:[UInt8]?,_ F:[UInt8]?) -> Int
    {
        let ge=FP48.fromBytes(E!)
        let gf=FP48.fromBytes(F!)
        var distance=[Int]();
        let t=FP48(gf);
        var table=[FP48]()
        
        var s:Int=1
        for _ in 0 ..< Int(TS)
        {
            distance.append(s)
            table.append(FP48(t))
            s*=2
            t.usqr()
 
        }
        t.one()
        var dn:Int=0
        for _ in 0 ..< TRAP
        {
            let i=Int(t.geta().geta().geta().geta().getA().lastbits(8))%TS
            t.mul(table[i])
            dn+=distance[i]
        }
        gf.copy(t); gf.conj()
        var steps=0; var dm:Int=0
        var res=0;
        while (dm-dn<Int(MAXPIN))
        {
            steps += 1;
            if steps>4*TRAP {break}
            let i=Int(ge.geta().geta().geta().geta().getA().lastbits(8))%TS
            ge.mul(table[i])
            dm+=distance[i]
            if (ge.equals(t))
            {
                res=dm-dn;
                break;
            }
            if (ge.equals(gf))
            {
                res=dn-dm
                break
            }
    
        }
        if steps>4*TRAP || dm-dn>=Int(MAXPIN) {res=0 }    // Trap Failed  - probable invalid token
        return res
    }
    // Functions to support M-Pin Full
    
    static public func PRECOMPUTE(_ TOKEN:[UInt8],_ CID:[UInt8],_ G1:inout [UInt8],_ G2:inout [UInt8]) -> Int
    {
        let T=ECP.fromBytes(TOKEN);
        if T.is_infinity() {return INVALID_POINT}
    
        let P=ECP.mapit(CID)
    
        let Q=ECP8.generator();
    
        var g=PAIR256.ate(Q,T)
        g=PAIR256.fexp(g)
        g.toBytes(&G1)
    
        g=PAIR256.ate(Q,P)
        g=PAIR256.fexp(g)
        g.toBytes(&G2)
    
        return 0
    }
    
    static public func HASH_ALL(_ sha:Int,_ HID:[UInt8],_ xID:[UInt8]?,_ xCID:[UInt8]?,_ SEC:[UInt8],_ Y:[UInt8],_ R:[UInt8],_ W:[UInt8]  ) -> [UInt8]
    {
        var T=[UInt8](repeating: 0,count: 10*EFS+4)
        var tlen=0

        for i in 0 ..< HID.count  {T[i]=HID[i]}
        tlen+=HID.count
        if xCID != nil {
            for i in 0 ..< xCID!.count  {T[i+tlen]=xCID![i]}
            tlen+=xCID!.count
        } else {
            for i in 0 ..< xID!.count {T[i+tlen]=xID![i]}
            tlen+=xID!.count
        }
        for i in 0 ..< SEC.count {T[i+tlen]=SEC[i]}
        tlen+=SEC.count;
        for i in 0 ..< Y.count {T[i+tlen]=Y[i]}
        tlen+=Y.count;
        for i in 0 ..< R.count {T[i+tlen]=R[i]}
        tlen+=R.count;
        for i in 0 ..< W.count {T[i+tlen]=W[i]}
        tlen+=W.count;

        return hashit(sha,0,T);
    }

    // calculate common key on client side
    // wCID = w.(A+AT)
    static public func CLIENT_KEY(_ sha:Int,_ G1:[UInt8],_ G2:[UInt8],_ pin:Int32,_ R:[UInt8],_ X:[UInt8],_ H:[UInt8],_ wCID:[UInt8],_ CK:inout [UInt8]) -> Int
    {
        let g1=FP48.fromBytes(G1)
        let g2=FP48.fromBytes(G2)
        let z=BIG.fromBytes(R)
        let x=BIG.fromBytes(X)
        let h=BIG.fromBytes(H)
    
        var W=ECP.fromBytes(wCID)
        if W.is_infinity() {return INVALID_POINT}
    
        W=PAIR256.G1mul(W,x)
    
     //   let f=FP2(BIG(ROM.Fra),BIG(ROM.Frb))
        let r=BIG(ROM.CURVE_Order)
     //   let q=BIG(ROM.Modulus)
    
        z.add(h)   // new
        z.mod(r)

        g2.pinpow(pin,PBLEN)
        g1.mul(g2)

        let c=g1.compow(z,r)

        let t=mpin_hash(sha,c,W)

        for i in 0 ..< ECP.AESKEY {CK[i]=t[i]}
    
        return 0
    }
    // calculate common key on server side
    // Z=r.A - no time permits involved
    
    static public func SERVER_KEY(_ sha:Int,_ Z:[UInt8],_ SST:[UInt8],_ W:[UInt8],_ H:[UInt8],_ HID:[UInt8],_ xID:[UInt8],_ xCID:[UInt8]?,_ SK:inout [UInt8]) -> Int
    {
   //     var t=[UInt8](count:EFS,repeatedValue:0)
    
        let sQ=ECP8.fromBytes(SST)
        if sQ.is_infinity() {return INVALID_POINT}
        let R=ECP.fromBytes(Z)
        if R.is_infinity() {return INVALID_POINT}
        var A=ECP.fromBytes(HID)
        if A.is_infinity() {return INVALID_POINT}
    
        var U:ECP
        if xCID != nil
            {U=ECP.fromBytes(xCID!)}
        else
            {U=ECP.fromBytes(xID)}
        
        if U.is_infinity() {return INVALID_POINT}
    
        let w=BIG.fromBytes(W)
        let h=BIG.fromBytes(H)
        A=PAIR256.G1mul(A,h)
        R.add(A); R.affine()

        U=PAIR256.G1mul(U,w)
        var g=PAIR256.ate(sQ,R)
        g=PAIR256.fexp(g)
    
        let c=g.trace()
        
        let t=mpin_hash(sha,c,U)
 
        for i in 0 ..< ECP.AESKEY {SK[i]=t[i]}
    
        return 0
    }
    
    // return time since epoch
    static public func GET_TIME() -> Int32
    {
        let date=Date()
        return (Int32(date.timeIntervalSince1970))
    }

    // Generate Y = H(epoch, xCID/xID)
    static public func GET_Y(_ sha:Int,_ TimeValue:Int32,_ xCID:[UInt8],_ Y:inout [UInt8])
    {
        let h = MPIN256.hashit(sha,TimeValue,xCID)
        let y = BIG.fromBytes(h)
        let q=BIG(ROM.CURVE_Order)
        y.mod(q)
    //if ROM.AES_S>0
    //{
    //  y.mod2m(2*ROM.AES_S)
    //}
        y.toBytes(&Y)
    }
    // One pass MPIN Client
    static public func CLIENT(_ sha:Int,_ date:Int32,_ CLIENT_ID:[UInt8],_ RNG:RAND?,_ X:inout [UInt8],_ pin:Int32,_ TOKEN:[UInt8],_  SEC:inout [UInt8],_ xID:inout [UInt8]?,_ xCID:inout [UInt8]?,_ PERMIT:[UInt8]?,_ TimeValue:Int32,_ Y:inout [UInt8]) -> Int
    {
        var rtn=0
        //var xID=xID 
  
        rtn = MPIN256.CLIENT_1(sha,date,CLIENT_ID,RNG,&X,pin,TOKEN,&SEC,&xID,&xCID,PERMIT!)

        if rtn != 0 {return rtn}
    
        if date==0 {MPIN256.GET_Y(sha,TimeValue,xID!,&Y)}
        else {MPIN256.GET_Y(sha,TimeValue,xCID!,&Y)}
    
        rtn = MPIN256.CLIENT_2(X,Y,&SEC)
        if (rtn != 0) {return rtn}
    
        return 0
    }
    // One pass MPIN Server
    static public func SERVER(_ sha:Int,_ date:Int32,_ HID:inout [UInt8],_ HTID:inout [UInt8]?,_ Y:inout [UInt8],_ SST:[UInt8],_ xID:[UInt8]?,_ xCID:[UInt8],_ SEC:[UInt8],_ E:inout [UInt8]?,_ F:inout [UInt8]?,_ CID:[UInt8],_ TimeValue:Int32) -> Int
    {
        var rtn=0
    
        var pID:[UInt8]
        if date == 0
            {pID = xID!}
        else
            {pID = xCID}
    
        SERVER_1(sha,date,CID,&HID,&HTID);
    
        GET_Y(sha,TimeValue,pID,&Y);
    
        rtn = SERVER_2(date,HID,HTID!,Y,SST,xID,xCID,SEC,&E,&F);
        if rtn != 0 {return rtn}
    
        return 0
    }
   
}
 



