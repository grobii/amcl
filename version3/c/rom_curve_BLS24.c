#include "arch.h"
#include "ecp_BLS24.h"

/* Curve BLS24 - Pairing friendly BLS24 curve */

#if CHUNK==16

#error Not supported

#endif

#if CHUNK==32
// Base Bits= 29

const int CURVE_A_BLS24= 0;
const int CURVE_B_I_BLS24= 19;
const BIG_480_29 CURVE_B_BLS24= {0x13,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0};
const BIG_480_29 CURVE_Order_BLS24= {0x10000001,0xD047FF,0x1FD54464,0x1E3CE067,0xE322DDA,0x1D356F3F,0x7433B44,0x49091F9,0x1729CC2,0x250286C,0x16E62ED,0xB403E1E,0x1001000,0x80,0x0,0x0,0x0};
const BIG_480_29 CURVE_Gx_BLS24= {0xBE3CCD4,0x33B07AF,0x1B67D159,0x3DFC5B5,0xEBA1FCC,0x1A3C1F84,0x56BE204,0xEF8DF1B,0x11AE2D84,0x5FEE546,0x161B3BF9,0x183B20EE,0x1EA5D99B,0x14F0C5BF,0xBE521B7,0x17C682F9,0x1AB2};
const BIG_480_29 CURVE_Gy_BLS24= {0x121E5245,0x65D2E56,0x11577DB1,0x16DACC11,0x14F39746,0x459F694,0x12483FCF,0xC828B04,0xFD63E5A,0x7B1D52,0xAFDE738,0xF349254,0x1A4529FF,0x10E53353,0xF91DEE1,0x16E18D8A,0x47FC};

const BIG_480_29 CURVE_Bnx_BLS24= {0x11FF80,0x80010,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0};
const BIG_480_29 CURVE_Cof_BLS24= {0x19F415AB,0x1E0FFDFF,0x15AAADFF,0xAA,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0};
const BIG_480_29 CURVE_Cru_BLS24= {0xDD794A9,0x1DE138A3,0x2BCCE90,0xC746127,0x15223DDC,0x1DD8890B,0xED08DB7,0xE24B9F,0xE379CE6,0x37011AC,0x11BAC820,0x1EEFAD01,0x200860F,0x147218A6,0xF16A209,0xF0079,0x555C};
const BIG_480_29 CURVE_Pxaa_BLS24= {0x14E24678,0x1F149A9B,0x9609022,0x1C186868,0xCDEFC69,0x1C87BB2E,0x14A2235F,0x7586755,0x5896747,0x159BFE92,0x3B5572E,0x1710A521,0x71EB14A,0xC643C33,0x12581DE5,0x1BCA747D,0x959};
const BIG_480_29 CURVE_Pxab_BLS24= {0x1FB099B8,0x3FCF5D7,0x4A91C0E,0xC6EEB40,0x11FC2385,0x11B5AE8D,0x1A9CC3E7,0x194FE144,0x185DB2A5,0x930E1C7,0x14F85F9A,0x1F2ED4E,0x1D1BE5AD,0xF26169C,0xCF7F194,0x1DA1062E,0x3B0D};
const BIG_480_29 CURVE_Pxba_BLS24= {0x11AD15D3,0xD0E6F38,0x17DB85BB,0x30A62F1,0x1EA3E09A,0x17B25FA1,0x1B7959AC,0x1165B19A,0x6C74FDB,0x18F790E1,0x12278FDA,0x1E008F79,0x103F329,0x14619FF1,0x1EBCAA8,0xFF5A9CA,0x3EC2};
const BIG_480_29 CURVE_Pxbb_BLS24= {0x1EE0F480,0x3D5943A,0xF5B12E3,0x128AADC8,0x180E1CB9,0x1EFD916F,0x48BC7F,0x1D5EE1FA,0x5698EF5,0x11D6AED9,0x1386BC6E,0x196E900B,0x1CE2E465,0xC2A8ED3,0x1E67DF99,0x71B7940,0xA5B};
const BIG_480_29 CURVE_Pyaa_BLS24= {0x14781AA0,0xC324C98,0xEDC2AC,0x16C13B46,0x145FC44B,0x12529530,0x1310A8C4,0x1768C5C0,0xE19AE68,0x56E1C1D,0x13DAF93F,0x17E94366,0xF901AD0,0x76800CC,0x10250D8B,0x1E6BAE6D,0x5057};
const BIG_480_29 CURVE_Pyab_BLS24= {0xEAE08FA,0xDDF62BF,0xA97E5AB,0xF0EE97,0x99A42CA,0x1C326578,0xF33DC11,0x8B913F7,0xFEF8552,0x19F35B90,0x58DDBDE,0xFC32FF2,0x1587B5DF,0xB5EB07A,0x1A258DE0,0x1692CC3D,0x2CE2};
const BIG_480_29 CURVE_Pyba_BLS24= {0x5F0CC41,0xB9813B5,0x14C2A87D,0xFF1264A,0x19AF8A14,0x6CE6C3,0x2A7F8A2,0x121DCA7D,0x7D37153,0x19D21078,0x15466DC7,0x1362982B,0x1DD3CB5B,0x1CFC0D1C,0x18C69AF8,0x8CC7DC,0x1807};
const BIG_480_29 CURVE_Pybb_BLS24= {0x115C1CAE,0x78D9732,0x16C26237,0x5A81A6A,0x1C38A777,0x56121FE,0x4DAD9D7,0x1BEBA670,0xA1D72FC,0xD60B274,0x19734258,0x1D621775,0x4691771,0x14206B68,0x17B22DE4,0x29D5B37,0x499D};
const BIG_480_29 CURVE_W_BLS24[2]= {{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}};
const BIG_480_29 CURVE_SB_BLS24[2][2]= {{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}},{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}}};
const BIG_480_29 CURVE_WB_BLS24[4]= {{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}};
const BIG_480_29 CURVE_BB_BLS24[4][4]= {{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}},{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}},{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}},{{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0},{0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}}};
#endif

#if CHUNK==64
// Base Bits= 56

const int CURVE_A_BLS24= 0;
const int CURVE_B_I_BLS24= 19;
const BIG_480_56 CURVE_B_BLS24= {0x13L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L};
const BIG_480_56 CURVE_Order_BLS24= {0x1A08FFF0000001L,0x1E7033FF551190L,0x6ADE7EE322DDAFL,0x848FC9D0CED13AL,0x50D81729CC224L,0x1F0F05B98BB44AL,0x10010010005A0L,0x0L,0x0L};
const BIG_480_56 CURVE_Gx_BLS24= {0x6760F5EBE3CCD4L,0xEFE2DAED9F4564L,0x783F08EBA1FCC1L,0xC6F8D95AF88134L,0xDCA8D1AE2D8477L,0x9077586CEFE4BFL,0x8B7FEA5D99BC1DL,0x17CAF9486DE9E1L,0x1AB2BE34L};
const BIG_480_56 CURVE_Gy_BLS24= {0xCBA5CAD21E5245L,0x6D6608C55DF6C4L,0xB3ED294F39746BL,0x145824920FF3C8L,0x63AA4FD63E5A64L,0x492A2BF79CE00FL,0x66A7A4529FF79AL,0x6C53E477B861CAL,0x47FCB70CL};

const BIG_480_56 CURVE_Bnx_BLS24= {0x100020011FF80L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L};
const BIG_480_56 CURVE_Cof_BLS24= {0xC1FFBFF9F415ABL,0x5556AAB7FFL,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L};
const BIG_480_56 CURVE_Cru_BLS24= {0xBC27146DD794A9L,0x3A30938AF33A43L,0xB112175223DDC6L,0x125CFBB4236DFBL,0x2358E379CE607L,0xD680C6EB20806EL,0x314C200860FF77L,0x3CBC5A88268E4L,0x555C0078L};
const BIG_480_56 CURVE_Pxaa_BLS24= {0xE2935374E24678L,0xC34342582408BL,0xF765CCDEFC69EL,0xC33AAD2888D7F9L,0x7FD2458967473AL,0x52908ED55CBAB3L,0x786671EB14AB88L,0xA3EC96077958C8L,0x959DE53L};
const BIG_480_56 CURVE_Pxab_BLS24= {0x7F9EBAFFB099B8L,0x3775A012A47038L,0x6B5D1B1FC23856L,0x7F0A26A730F9E3L,0x1C38F85DB2A5CAL,0x76A753E17E6926L,0x2D39D1BE5AD0F9L,0x31733DFC651E4CL,0x3B0DED08L};
const BIG_480_56 CURVE_Pxba_BLS24= {0xA1CDE711AD15D3L,0x853178DF6E16EDL,0x64BF43EA3E09A1L,0x2D8CD6DE566B2FL,0xF21C26C74FDB8BL,0x47BCC89E3F6B1EL,0x3FE2103F329F00L,0x4E507AF2AA28C3L,0x3EC27FADL};
const BIG_480_56 CURVE_Pxbb_BLS24= {0x7AB2875EE0F480L,0x4556E43D6C4B8CL,0xFB22DF80E1CB99L,0xF70FD0122F1FFDL,0xD5DB25698EF5EAL,0x4805CE1AF1BA3AL,0x1DA7CE2E465CB7L,0xCA0799F7E65855L,0xA5B38DBL};
const BIG_480_56 CURVE_Pyaa_BLS24= {0x86499314781AA0L,0x609DA303B70AB1L,0xA52A6145FC44BBL,0x462E04C42A3124L,0xC383AE19AE68BBL,0xA1B34F6BE4FCADL,0x198F901AD0BF4L,0x736C094362CED0L,0x5057F35DL};
const BIG_480_56 CURVE_Pyab_BLS24= {0xBBEC57EEAE08FAL,0x78774BAA5F96ADL,0x64CAF099A42CA0L,0xC89FBBCCF70478L,0x6B720FEF855245L,0x97F916376F7B3EL,0x60F5587B5DF7E1L,0x61EE89637816BDL,0x2CE2B496L};
const BIG_480_56 CURVE_Pyba_BLS24= {0x730276A5F0CC41L,0xF89325530AA1F5L,0xD9CD879AF8A147L,0xEE53E8A9FE2880L,0x420F07D3715390L,0x4C15D519B71F3AL,0x1A39DD3CB5B9B1L,0x3EE631A6BE39F8L,0x18070466L};
const BIG_480_56 CURVE_Pybb_BLS24= {0xF1B2E6515C1CAEL,0xD40D355B0988DCL,0xC243FDC38A7772L,0x5D338136B675CAL,0x164E8A1D72FCDFL,0xBBAE5CD0961ACL,0xD6D04691771EB1L,0xD9BDEC8B792840L,0x499D14EAL};
const BIG_480_56 CURVE_W_BLS24[2]= {{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}};
const BIG_480_56 CURVE_SB_BLS24[2][2]= {{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}},{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}}};
const BIG_480_56 CURVE_WB_BLS24[4]= {{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}};
const BIG_480_56 CURVE_BB_BLS24[4][4]= {{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}},{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}},{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}},{{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L},{0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L,0x0L}}};

#endif