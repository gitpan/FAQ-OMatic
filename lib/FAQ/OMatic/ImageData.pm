##############################################################################
# The Faq-O-Matic is Copyright 1997 by Jon Howell, all rights reserved.      #
#                                                                            #
# This program is free software; you can redistribute it and/or              #
# modify it under the terms of the GNU General Public License                #
# as published by the Free Software Foundation; either version 2             #
# of the License, or (at your option) any later version.                     #
#                                                                            #
# This program is distributed in the hope that it will be useful,            #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with this program; if not, write to the Free Software                #
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.#
#                                                                            #
# Jon Howell can be contacted at:                                            #
# 6211 Sudikoff Lab, Dartmouth College                                       #
# Hanover, NH  03755-3510                                                    #
# jonh@cs.dartmouth.edu                                                      #
#                                                                            #
# An electronic copy of the GPL is available at:                             #
# http://www.gnu.org/copyleft/gpl.html                                       #
#                                                                            #
##############################################################################

###
### ImageData.pm
###
### GIFs and JPGs are ASCII-encoded into this file. It's the most
### portable (across web server configurations) and easy to install
### way I could find to distribute all the sundry little icons.
### All faqomatic installations should write the images out to a
### web-servable directory, for speed in serving them, and so that
### they're cachable.
###

package FAQ::OMatic::ImageData;

%img = ();		# actual image data

# to regenerate:
#:.,$-2!(cd ../../../img; encodeBin.pl * | grep -v '^$type')
$img{'ans-also'} = <<__EOF__;
47494638396115000e00c200000000008888880000dcffffffff00ff00000000
000000000021f90401000004002c0000000015000e0000034548ba0bfe8fc936
aa1d6e4a50b9e5804681436046a2e794662712de758592a0a87227ec0b0faea6
1660472c76302c21a1c8cccd7acd645059b371a68167ede6fcbc20e04702003b
__EOF__

$img{'ans-del-part'} = <<__EOF__;
47494638396117001c00c20000000000888888ffffffdc0000ff00ff00000000
000000000021f90401000004002c0000000017001c0000037c08badc4a300241
abbd2f9229d6c59d3671dd577180545253e0bec11a6ee528c02e6ba5a842e139
87ef4432618ac6e450963cea90cd8e4d7703e688528f35e62471ac9f256540fe
90073be8d9b24e5760e7f8808bfde1e2b8badd254787a1026d6d6e6c8381864b
5b7984558a2f8c8e4662517f944a809659429b0e09003b
__EOF__

$img{'ans-dup-ans'} = <<__EOF__;
47494638396118001700c20000000000888888ffffff980065ff00ff00000000
000000000021f90401000004002c000000001800170000037b08ba4bfe300241
ab5031bf79ed045af67541d9841ba50865a0a2a9550d746d0f10c751774fa70b
5680c628d61ca349892853018e3b0bb353f9d494ade520290c2c9859d774d552
4d65e7e68558548cd54f9c8619ccaee5193aa91c0fa59b7d735b5d61777e8385
553f8251808b795b6d4678113e96949597360409003b
__EOF__

$img{'ans-dup-part'} = <<__EOF__;
47494638396117002000c20000000000888888ffffff980065bbbbbbff00ff00
000000000021f90401000005002c000000001700200000038708badc5a300241
abbd2f9629d6c59d3671dd577180545213e1bec41a6ee528c02e6ba5a842e139
87ef4432618ac6e450963cea90cd8e4d7703e688528f35e62471ac9f65d4241e
3b7f5bd8b9ea1ab8b7d8cacb3db892a1027ab44cef2b4901817d0381856b8501
74888671028b848c6178665294777270464b69408d6c696b969ea25942a60e09
003b
__EOF__

$img{'ans-edit-part'} = <<__EOF__;
47494638396120001f00e30000000000cbcbffffcb99fdfd008888889999ffff
ffffff65cb980065ff00ff00000000000000000000000000000000000021f904
01000009002c0000000020001f000004ca30c949abbde7ea6d8fcf5cd87d0760
9e686a6e40107c8021cf74bd5e4051b8a57cd63603c0d20ae886b1980f38530e
29395700296c1a08d82ca1ea9b0006035d4192acc6b4d865930c16089e4e930c
9d5699da6f2f4dce647ef14f094a7d843e80505685368788668a7b8c7a834a74
5986036e819228579590987915656a9e9799388f367fa744a99facad73956842
91a233b374006ea1a8b8a54dbc9ab7ae3ebb37bec53fc38d0608cfd0d1d0424e
2c33d2d8d093d632d9d37edcc57be1e25d1a83e5422c76ec761b11003b
__EOF__

$img{'ans-ins-part'} = <<__EOF__;
47494638396120002000c20000000000ffcb99fdfd00888888ffffff980065bb
bbbbff00ff21f90401000007002c00000000200020000003ca780adcfe4cc949
0f2038eb1dabbf44b371a1575d60386620604e284b18746da898fb5a6a6cd339
8dced462607e40c8f0244cad382fe773baa4a4a453563488cd5661381cb226b4
4a508ed9d8963b0302e730680d6c5b02f878d6cbc007047a7b2b7d7802868174
75396f7e860200050b1989498c858e2e05914e7421967f983a9a055d239f8e8f
55a38296a81d15ab0403b3b4b30d97465f12b1b5b64a2d26bcbdc3a61eb18283
b09aa5c85f9a3c47948a251491d0d194654493d264d41fc84fba92e1c544bfe8
0f1509003b
__EOF__

$img{'ans-opts'} = <<__EOF__;
47494638396117001c00a10000000000ffffffff00ff00004021f90401000002
002c0000000017001c00000254848f69c20d01a39cab8937737cc0629d611df3
81d23796265476eaaa18eb2ccf666d6b784ebd7cb0fbb15e41505064ab218631
940a4923fa42d35c7153054ea13a9182b91c1a59b7ea152beca54fd968f39d28
00003b
__EOF__

$img{'ans-reorder'} = <<__EOF__;
47494638396117001c00c20000000000888888ffffff980065ff00ff00000000
000000000021f90401000004002c0000000017001c0000038408badc4a300241
abbd2f9229d6c59d3671dd577180545253e0bec11a6ee528c02e6ba5a842e139
87ef4432618ac6e450963cea90cd8e4d7703ba0644a9c7fa1a60a5252c0768f9
2ebd510afaecfd26d79c36961b13c0edd8393d2f9ea07f3815722c7e6e468384
78698a8976165682597874303b240374464b8b4e9c1f9b9e8442a34209003b
__EOF__

$img{'ans-small'} = <<__EOF__;
4749463839610c000e00a10000000000888888ffffffff00ff21f90401000003
002c000000000c000e00000229847fa320ed6256638e8161a1081c4dc605df43
4214451a26189a1acbb9650587b16a8bf44c23be5100003b
__EOF__

$img{'ans-title'} = <<__EOF__;
47494638396120002000e30000000000cbcbffffcb99fdfd008888889999ffff
ffffff65cbff00ffb3006102000920002001000100000000000000000021f904
01000008002c00000000200020000004ae10c949abade7ea6d8fcf5cd87d9e68
0241f0996751a420bba1810bc821f0a637ae018381abe09b0505825eb1021c20
95cb49d3998c328f55ab140bd5369fda2db56bfd66c366b214c06ebbdf6c2edc
6da8dbeff8343ebfefd7f57e0600817b0048498482796d858783848f826c7f93
766c88898f95779b8c898a9285919b9994a275040004abacadae9a91968faeb4
b4b07fb276b5bba9a6a1bf9f7c948374a8bcb5b1929ebac7af7ec5cd04151100
3b
__EOF__

$img{'ans-to-cat'} = <<__EOF__;
4749463839611d001a00c20000000000fffecb555555888888ffffff980065bb
bbbbff00ff21f90401000007002c000000001d001a000003a478aad2ee2bcac9
88bda4d11d85f59727709c9811460a9113d8a0e9c7b6589dcd926bdff822bea9
d8a85731c500c8640f54030406d04120a9a478824167541ae87a01565890e0f4
9aa955dfae8c469aa78a02e3e170badf6ff041ceb177b7515d7a05847c137e4f
805c8385848753787971851b497f805f7b9495658a8b9386a08d9167a0138d05
65a4709a9ba2a900b1b2b3b10ba8b7a13db8728e44118db6be33b93309003b
__EOF__

$img{'ans'} = <<__EOF__;
47494638396117001c00a10000000000888888ffffffff00ff21f90401000003
002c0000000017001c00000267848f69c30d02a39cab8d27cea4d93e9c6d1106
3821f404ea1a9cdd157e02aba252491a105d2bfa08125182c2e2cf551cda88c9
8ccc36e3d5804e8db4a50461a49b6353e4fd2a7757d6385a36a382572353bc86
8341e9d5b96ea792db7379f70d17e6e743585800003b
__EOF__

$img{'cat-also'} = <<__EOF__;
47494638396119000e00c20000000000fffecb8888880000dcffffffff00ff00
000000000021f90401000005002c0000000019000e0000035058ba0cfe2cca05
82b8223c389bc541286a1d358e1b37555aca8a8034289573dec0a02f7b1d62c0
504c472c12343fe045a8283a913714c33920d83e41a66c76552e499359e11ad5
96c8e55869ec6a2b12003b
__EOF__

$img{'cat-del-part'} = <<__EOF__;
47494638396120001b00c20000000000fffecb888888ffffffdc0000ff00ff00
000000000021f90401000005002c0000000020001b000003955805dc0e2aca49
41b8380748fbb481208ee2c5791d1892a5f9bc8ca46a74ad9d8badbbb0b3dbb3
1ae327fc0d33bd873187242e8341e78d69d2b0ae2d247593c15e692755548a09
973384742d4d0047405176fb2217beab18125bb01f69ef5c175772042453802a
2c846a767763016c18916e8e34756893261f81649495825e2c9e0a472ba1a265
158f6438a4ab52ad0b49b32f1309003b
__EOF__

$img{'cat-dup-ans'} = <<__EOF__;
4749463839611a001700c20000000000fffecb555555888888ffffff980065ff
00ff00000021f90401000006002c000000001a00170000038e68b26cfe304211
861d813529e9c541280a5c4489a8b695a7baa059e9502f1c1478ae1753167e83
9d10f7a0fd3e388072b9cccd7cb624614a25289d8ce3456aad02acb91a3058f8
9a099766a1162d4f9568cb1bc78671ab5eba8bc1fde2c13c32524b7172004482
6e671f803206777f8d895f6386882552407981986e91739c1c494ca457a11243
a9a7a8aa3a0609003b
__EOF__

$img{'cat-dup-part'} = <<__EOF__;
47494638396120001b00c20000000000fffecb888888ffffff980065bbbbbbff
00ff00000021f90401000006002c0000000020001b0000038e6806dc0e2aca49
41b8380748fbb441218ee2c5791d1892a5f9bc8ca46a74ad9d8badbbb0b3dbb3
1ae327fc0d33bd873187242e834196b48581cca25316cdda74ea4eaaa0171909
67b2da5bd9742611ded2ed7aa37b13967371c0ceffcad8357c777e6b33028788
768802427f2a8b8b04908c648e63401f7497723233686955152a9f238d1f7a97
380a49ac301309003b
__EOF__

$img{'cat-edit-part'} = <<__EOF__;
47494638396120001f00e30000000000cbcbfffffecbffcb99fdfd0088888899
99ffffffffff65cb980065ff00ff00000000000000000000000000000021f904
0100000a002c0000000020001f000004cb50c949abbd0ae1cd27fa5a27526038
8a40107c12e0be30700286a12a80a0efbc2077a9404d9613148ec8a3eeb7a1a9
02ae5d12b98b59010442cd7028f6be601e96301800bae1f412962de7a26ab077
4c36fbbc7171b56dbff7ae563c7c45447f797b7584388687636e558b553d5353
8e7d3e914b3c9449967313738d9e902d9279a3a491789c48a84ba09a3aacad65
9798b03e52495f00b5784caa8777b6b7a578712fbc146f3c09cecfd009706215
cc3ad1d8d272d5b9c261c038c7dea9a0e2e3c5e5e7cad580ed801511003b
__EOF__

$img{'cat-ins-part'} = <<__EOF__;
47494638396120001b00e30000000000fffecbffcb99555555fdfd00888888ff
ffff980065bbbbbbff00ff00000000000000000000000000000000000021f904
01000009002c0000000020001b000004a730a541ab1d32ebcd47f86018605cb9
7901a2aeea479a259ab2ad7bdd94268b7c2fbe139fd086b30c7dbb1ee5a83c2e
43c58bd3904c327903eaef3accee92349a1000f886c2e21e59107471d50081bc
3d7a87d67201e180daa1d3017179048407076e207f2b20827a84040086875647
6482846412929463969e3a922005a3a4a5a44a3a01a1a6aca65027a1763f1a9b
b258b47c898a35b7b44f33bb08a8279c6f401251c9381b11003b
__EOF__

$img{'cat-new-ans'} = <<__EOF__;
47494638396120002000c20000000000fffecb888888ffffff980065bbbbbbff
00ff00000021f90401000006002c00000000200020000003c26846dcfe4ec939
09b838ebcba85fc0208e64c9115f150e5869b25d0ab2e3ead2309a5a382dfc40
410f10a31043485f50d8cb798ea2d660f9636d8a06408157b3dd4c582df74b8e
86b736ef77c346479b2e6da030afd30b17775a441500ec8074793c6c85778173
83481788878e888a51728f948d917f95999062489a9e75000a50988da58ea159
849f9fa84793a6b078a216a4ab9612aeb69aa8a98cbab7b3b5b1a5bc47bf95bc
bdc39ec95aafc7a01379cbc446c2d0b2d2cfd487c95985e0e01309003b
__EOF__

$img{'cat-new-cat'} = <<__EOF__;
47494638396120002000c20000000000fffecb888888ffffff980065bbbbbbff
00ff00000021f90401000006002c00000000200020000003ba686ad4fe6dc949
1901386bc8dd6c40208e24d09dcb350a6c2b885abc116918b82e2cefb4a292c0
802d0834d5761a22d168306194d065cf398c5a8d80c2a56a8562b5cfae0e9901
73bd81427aad5663c062589bcd7effc89ab93e0d68c285747b82747d59778388
81857059818e898b2a218994420b4e4295947d0a98938fa0739c4d5ba1a66da3
549aa1a3a42aab83ad59058db08a1259b5a7a0b2b4bb9013b9b682ad7e9fc36b
c54fc8a2146fbf8fc54dc7d0cdc178d81a1309003b
__EOF__

$img{'cat-opts'} = <<__EOF__;
47494638396120001b00a10000000000fffecbffffffff00ff21f90401000003
002c0000000020001b00000276dc80a960ed0f4198b40606f393b6639d719db5
9489238eaafa1deb6b962f3b23f398e279bcd46e95bb797e94a01048bc1c6149
e3f2d210056dc78f9424103887068e3491e5eda2936958d8f2eaaaa8f213d7de
96e550b21c70666d94c5525856b6779707874277b1d5d275e8b3c1c8e4282679
e25000003b
__EOF__

$img{'cat-reorder'} = <<__EOF__;
47494638396120001b00c20000fffecb555555888888ffffff980065ff00ff00
000000000021f90401000005002c0000000020001b000003945815dc1e2aca49
03b8380348fbb480208ee2c5791d1892a5f9bc8ca46a74ad9d8badbbb0b3dbb3
1ae327fc0d33bd873187242e8341e78d69226458d81692ba2158575912eda40a
78bdd2a94275fea631e40bda1a66b9e111101a5c17ed4d32725f2c3b77387a77
4e7f871b0089448b8116687d5a7b38397a952556971f8d696d7832518567a3a4
6f82a879a590ac6b49b22f1309003b
__EOF__

$img{'cat-small'} = <<__EOF__;
47494638396110000e00c20000000000fffecb888888ffffffff00ff00000000
000000000021f90401000004002c0000000010000e0000033648b04cfe0f0441
4560cdc96a83ff80f68d17c678e642aa2ab94ad2c451a87279337dd9b10b2aad
dc2f28dc017da3d0115903a6528e04003b
__EOF__

$img{'cat-title'} = <<__EOF__;
47494638396120002000e30000000000cbcbfffffecbffcb99fdfd0088888899
99ffffffffff65cbff00ff00000000000000000000000000000000000021f904
01000009002c000000002000200000049530c949aba5e8ea6d91cf5cd87d9e68
0241f099a761a420bba1810bc821f0a637ae010482cbe09b0507835eb1022420
95cb49d3998c328f55ab140bd5369fda2db56bfd66c36672341d96b0db89771b
803c9f00f8bc9efedce37f02818283027849848264008888798c894c81059394
9578959483508b8298969e058d529da0a5959a6e8faaab818eacaf8c9cb0b3ad
b4b6b2b6af11003b
__EOF__

$img{'cat'} = <<__EOF__;
47494638396120001b00c20000000000fffecb888888ffffffff00ff00000000
000000000021f90401000004002c0000000020001b0000037e4804dc0e2aca49
41b8380748fbb481208ee2c5791d1892a5f9bc8ca46a74ad9d8badbbb0b3dbb3
1ae327fc0d33bd873187242e8341e78d69d2b0ae2d247593c15e692755548a09
97c9c00868e66509d5d54bdb3d8573e524326e8d7ec3c77d7b7778737e7f1873
23860a16807a1f8e52388c914e930b954497499c301309003b
__EOF__

$img{'checked-large'} = <<__EOF__;
47494638396114001800a10000000000ff0000ffffffff00ff21f90401000003
002c000000001400180000025c9c8f69a19d01996b71d26a1fcc7af3837d8b37
00e6899e6129b4eedbae004c470032d3af8deb6e24b81d72905a5168984502bb
62b02758fe9c4856cc297d0ea74560ab9abb2e995fa8d85bde36d1daa491ec02
bf61e0942960af1600003b
__EOF__

$img{'checked'} = <<__EOF__;
47494638396110001100f10000000000ff0000ffffffff00ff21f90401000003
002c00000000100011000002399c8f1801edef1613b45a2ac1dd596fdb7d9524
3458c02da526a1a3ba9eb040c6b2ec9a383deb786dfbb928be9fa5783b7a4033
2224f2041400003b
__EOF__

$img{'help-small'} = <<__EOF__;
47494638396110000c00c20000000000fdfd00ffffffdc0000ff00ff00000000
000000000021f90401000004002c0000000010000c00000331484ad0de6bb510
86b501aa5907bd19c00054e77594539adf19ae285672b03c93b57be325788fb5
9506d83a0d250f472401003b
__EOF__

$img{'help'} = <<__EOF__;
47494638396120001800c20000000000fdfd00ffffffdc0000ff00ff00000000
000000000021f90401000004002c000000002000180000037a48ba4cf030b649
dd0b386b58e7d5c1208ae0d329001892d858569fe6ca6c6636a95a67e3f03239
d04cb8c3001641e2b05534a254cc1ecda73a2675521e151a83aeb65f6fa02b26
96c965661a2d5e7ad9de26d79156d78ff47a568ccfa7e51b3875771e57587c7d
82716e4e27704d372728704691923811999209003b
__EOF__

$img{'picker'} = <<__EOF__;
ffd8ffe000104a46494600010100000100010000ffdb00430008060607060508
0707070909080a0c140d0c0b0b0c1912130f141d1a1f1e1d1a1c1c20242e2720
222c231c1c2837292c30313434341f27393d38323c2e333432ffdb0043010909
090c0b0c180d0d1832211c213232323232323232323232323232323232323232
323232323232323232323232323232323232323232323232323232323232ffc0
0011080080010003012200021101031101ffc4001f0000010501010101010100
000000000000000102030405060708090a0bffc400b510000201030302040305
0504040000017d01020300041105122131410613516107227114328191a10823
42b1c11552d1f02433627282090a161718191a25262728292a3435363738393a
434445464748494a535455565758595a636465666768696a737475767778797a
838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7
b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae1e2e3e4e5e6e7e8e9eaf1
f2f3f4f5f6f7f8f9faffc4001f01000301010101010101010100000000000001
02030405060708090a0bffc400b5110002010204040304070504040001027700
0102031104052131061241510761711322328108144291a1b1c109233352f015
6272d10a162434e125f11718191a262728292a35363738393a43444546474849
4a535455565758595a636465666768696a737475767778797a82838485868788
898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4
c5c6c7c8c9cad2d3d4d5d6d7d8d9dae2e3e4e5e6e7e8e9eaf2f3f4f5f6f7f8f9
faffda000c03010002110311003f00f76171ef4a27f7ac95b8f7a9567f7ac5d4
3b1d0b1a625a51266a82cbef52ac950eb193a762e6fa5dd55d5ea4ddc543c419
b8d87eea37d445a985e8f6e64dd89fcca4f32ab9929864aa558ca552c5af368f
36a9997de8f36a955b99bae5df368f32a9f9b4be656aa5717b72df994be67bd5
4f3297ccad52b8beb05932534cdef559a4a89a6f7ad1532957b974cfef4d371e
f59ed3fbd44d71ef56a89a2a97350dd7bd27dafdeb1daebdea3fb5f3d6b45873
452b9b9f6af7a5fb4fbd620baf7a78b9f7a5ec0d52b9b3f69f7a5fb47bd638b9
f7a78b8f7a9f626aa9dcd5f3fde97cff007acb13fbd1e7fbd4ba5634540d3fb4
7bd1f68f7acbfb47bd27da3deb271b0fd81abf68f7a4fb47bd657da3de93ed1e
f593761fd5ccc4b8f7ab093fbd614571ef57229fdebce9d43d7a942c6d24bef5
6524ac88a5ab91495cb3ac7154a7634d1ea6ddc55289eaceef96b96588d4e1a9
1b0acd51b3d233540cf54ab9c151d87b4951b495134950b495aaac79f52a589c
cb4096a934b4096b7a756e71cabea5f12d2892a90969c24aefa72b99bae5d125
3849548494f1257a14d5c978827793deab3cdef4c964aa72cdef5db0a6694ebd
c9de7f7aacf71ef55659fdea9cb71ef5d50a27753a972f3dd7bd41f6be7ad664
975ef55fed7f375aea8e1f43b69cae6fadd7bd48b73ef580b75ef532dcfbd274
0efa6ae6eadcfbd4ab71ef588b73ef532dc7bd62e89df4e9dcd913fbd067f7ac
c59f8eb419fdeb0a94ac76c6868689b8f7a4371ef5986e3de9a6e3deb82a46c6
8a81a66e3de9a6e3deb30dc7bd30dc7bd79f51d8a58733a1b8e9cd68433f4e6b
9a82e3a735a904fd39af16ad43d4ad42c7410cbef5a10c958504bd2b4e093a57
9d56b1e4d6a7636a17ab7bbe5acd81fa55eddf20af3e788d4f26bc6c35daabbb
d3a46aad23d542b9e2d77611deabbc94923d55924ae98563c5af52c48d2f3409
6a93cbcd025aeca356ecf2675f53404b4f1255012d3c495ece1e573175cbe24a
7892a8892a41257b7415ccde2092692a84d37bd493c9d6b3279baf35eb52a674
51af71269fdea84d71ef4c9e7ebcd664f71d79af469513d6a352e4d35d7bd54f
b5fcdd6a8cf75d79aa3f6bf9cf35e8c30fa1eb5095ce892ebdeac25cfbd73b1d
d7bd598ee7dea2540f6a82b9d0a5cfbd584b8f7ac08ee7dead4771ef5cd2a27b
5429dcdc59f8eb419fdeb3127e3ad067f7ae3ad4ac8f5a1434340dc7bd30dc7b
d6735c7bd30dc7bd78d5e3636540d1371ef4c371ef59a6e3dea3371ef5e25776
3458728db5c671cd6b5b4fd39ae52d6e3a735b56b3f4e6be72bd43d0c4d0b1d4
5b4bd2b5ada4e95cddacbd2b6ad64e95e3d7ac78189a763a1b77e95a1bbe4159
16afd2b4f77eec57915711a9e0626362391aa9c8f534ad54a57eb574eb9f378a
762391ea9c9253a592a94b2576d3ac7cd62aa581e5e68596a9c92f342cb5e8e1
aadd9e0d4afa9a2b2d48b2567acb52ac95f498495ce79572fac952ac954164a9
564afa4c22b98cb103ae64eb59373375ab775275ac5ba9baf35f41429dcebc35
7b95ee67ebcd645cdc75e6a5ba9faf358b7571d79af628513dfc354b897175d7
9acefb5fce79aaf7575d79accfb5fef0f35ebd2c3e87bf8695ce923baf7ab91d
cfbd73315d7bd5d8ae7dea2a503e9308ae7491dcfbd5c8ee3deb9d8ae7deaec5
71ef5c55289f4b84a773a049f8eb434fef5971cfc75a1a7f7af3b134ac8f7a9d
0d0bed71ef51b5c7bd67b5c7bd44d71ef5f378b8d8e88d0341ae3dea36b8f7ac
e6b8f7a89ae3debe6b16ec6f1c395ed64e95b76b374ae66da4e95af6d374af02
bd3b9c989af73a9b59fa735b76b71d39ae4ada7e9cd6bdb5c74e6bc6af44f031
352e7616b738c735a9f6bfdd8e6b92b6bae9cd68fdabe41cd791570fa9f3f899
5cd196ebdea94b73ef54a4baf7aa725cfbd5d3a07cde2d5cb72dcfbd5296e3de
ab4973ef54e5b8f7aeda744f99c5d3b96249f9eb42cfef598f3f3d6859fdebd1
c3d2b33c0a94353656e3dea55b8f7ac65b8f7a916e3debe93091b1cf2a06d2dc
7bd4ab71ef588b71ef52adc7bd7d3611d8c65872edd5c75e6b16ea7ebcd4b737
1d79ac8b99faf35f4142a1d986a162b5d4bd6b12ea4eb576e65ebcd645cc9d6b
d8a15ac7bf86a7633ee9fad666efde1ab972f9cd67eefde1af62962343e830d1
b17a26abd13d6644d56e27acea573e9308ec6ac5255e8a4ac88deae47257154a
c7d2e12a58d88e5e291a5aa692f1434b5e6e26add1efd3afa13b4b513495034b
51b495f378b95ce98d726692a2692a1692a3692be6b16ae6d1c411c1274ad482
6e9cd60432568433579b5699f375abdce8a09fa735a905c74e6b99867f7ad086
e3a735e6d5a27935aa5cea60b9e9cd5efb5fc9d6b9886eba73573ed7f2f5af3a
74353c8af2b9a925d7bd5592e7deb39eebdeabbdcfbd5c281e2e215cbf25cfbd
5592e3dea93dcfbd577b8f7ae98513c4c453b971e7e7ad027f7acb69f9eb409f
debb28d2b33c99d0d4d8171ef4f171ef5902e3de9e2e3debdac3c6c62e81b02e
3dea4171ef58c2e3de9e2e3debdbc3bb19bc397e7b8ebcd664f3f5e6926b8f7a
cf9a7f7af5a9543a2850b0c9e5ebcd664f275a9a697deb3e692bd2a558f5e8d3
b15677aa3bbe7356267aa7bbe6af46188d0f5a846c5c8daad46f59e8d5651ea2
75cf6b0eec68c7255a8e4acc492ac2495cd3ac7b787a9635125e2832d535978a
432d71d6ab747ad0afa164cb4c3255632d30c95e2e22573655cb064a8cc95019
29864af1310ae68b1043149572297deb2124ab31cbef5cd3a67cfd4af736e29f
deae4571ef58293fbd598ee3deb92744e1a952e74515d7bd59fb5fcbd6b9d8ee
bdea6fb5f1d6b96587d4e2a92b9aed75ef50bdcfbd65b5d7bd44d73ef4e340f3
eaab9a4d73ef50b5c7bd67b5cfbd44d71ef5b4689e7d5a772fb4fcf5a04fef59
867f7a04fef5bd3a56670ca86a6b0b8f7a70b8f7ac9171ef4a2e3debd0a51b10
e81ae2e3de9e2e3deb1c5c7bd385c7bd7a149d8878734a5b8f7aa52cfef55dee
3deab493fbd7742a1ad3a1625965aa52c948f2fbd56924aea856b1dd4e9d86ca
f55b77cd4e77a877735d51c46876d38d8b2ad532bd5356a955e94ab9e852762e
a4953ac959eaf52ac958cab1e852a9634565a0cb5484b4196b0a956e7746be85
a32d34c9554cb4864af3eacae5aae5932530c955cc94d32579f555cb5882bac9
52acbef59e24a709a93a6784ebdcd459fdea55b8f7ac813fbd385c7bd43a3732
752e6dadd7bd49f6ae3ad610b9f7a5fb57bd66f0e64e57364dd7bd34dcfbd63f
dabde90dcfbd3540ca4ae6b1b9f7a61b8f7acbfb4fbd27da3dea95131953b9a4
67f7a5f3fdeb2fcfa3cff7aa54ac66e81abf68f7a5fb47bd657da3de8fb47bd6
b18d85ec0d6fb47bd2fda3deb23ed1ef4bf68f7ada2ec2fab9a8d71ef5134fef
59e6e3de9a66f7ad5541aa162e34bef51349558cb4d3255aac6aa9d8959ea3dd
cd30be6937568b106aa36260d4f0f55f75287a4eb9ac5d8b41e9e24aa7e652f9
952eb1b46a58bc25a4f36a9f9bef479b52eadcd1572df9b49e6554f368f32b19
4ae3f6e5af3293ccaade65279959495c7f583fffd9
__EOF__

$img{'space-large'} = <<__EOF__;
47494638396114001900f00000ffffff00000021f90401000000002c00000000
14001900000214848fa9cbed0fa39cb4da8bb3debcfb0f86e28814003b
__EOF__

$img{'space'} = <<__EOF__;
47494638396110001000f00000ffffff00000021f90401000000002c00000000
1000100000020e848fa9cbed0fa39cb4da8bb33e05003b
__EOF__

$img{'unchecked'} = <<__EOF__;
47494638396110001000a10000000000ffffffff00ff00004021f90401000002
002c0000000010001000000220848f69c1edbe9e6471be6a1bce61676f819328
9117c041684aadaca92ab25100003b
__EOF__

1;
