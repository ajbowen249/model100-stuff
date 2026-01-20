0 ' exploration system
1 dim ad$(2,7)
2 dim as%(2,2)
3 dim ao%(2,5,4)
4 dim ap$(2,5)

10 ca%=0
11 px%=0
12 py%=0
13 ex%=0
14 la%=-1
15 nx%=-1
16 ny%=-1
17 co%=-1
18 no%=-1

49 ' �����������
50 ad$(0,0)="��������������������"
51 ad$(0,1)="�                  �"
52 ad$(0,2)="�  �               �"
53 ad$(0,3)="� ���      �       �"
54 ad$(0,4)="�  �               �"
55 ad$(0,5)="�                   "
56 ad$(0,6)="��������������������"
58 as%(0,0)=7
59 as%(0,1)=3
60 ao%(0,0,0)=1
61 ao%(0,0,1)=19
62 ao%(0,0,2)=5
63 ao%(0,0,3)=1
64 ao%(0,1,0)=2
65 ao%(0,1,1)=11
66 ao%(0,1,2)=3
67 ao%(0,1,3)=3
68 ap$(0,1)="Talk"

70 ad$(1,0)="��������������������"
71 ad$(1,1)="�                  �"
72 ad$(1,2)="�                  �"
73 ad$(1,3)="�      ����        �"
74 ad$(1,4)="�         �        �"
75 ad$(1,5)="       �  �        �"
76 ad$(1,6)="��������������������"
78 as%(1,0)=1
79 as%(1,1)=5
80 ao%(1,0,0)=1
81 ao%(1,0,1)=0
82 ao%(1,0,2)=5
83 ao%(1,0,3)=2


797 gosub 10000
798 gosub 25000
799 goto 900

850 gosub 2000
851 la%=ca%

900 ' main loop
901 if la% <> ca% then gosub 850
910 gosub 3000
911 if nx%<>px% or ny%<>py% then gosub 1100:gosub 1200
912 if no%<>co% then co%=no%:gosub 1150:gosub 1170
999 goto 900

1000 ' render current area
1010 for i%=0 to 6 step 1
1020   print ad$(ca%, i%);
1021   if i%<6 then print ""
1030 next i%
1040 return

1100 ' render player at next pos
1101 print @(py% * 40) + px%, " "
1102 print @(ny% * 40) + nx%, chr$(147)
1110 px%=nx%
1120 py%=ny%
1130 return

1150 ' clear hud area
1151 for i% = 0 to 6 step 1
1152   print @(i%*40)+20, "                    ";
1158 next i%
1159 return

1170 ' render status if needed
1171 if co%<0 then return
1172 print @61, ap$(ca%,co%)
1173 return
1200 ' check area objects
1201 no%=-1
1210 for i%=0 to 4 step 1
1220   ot%=ao%(ca%,i%,0)
1221   ox%=ao%(ca%,i%,1)
1222   oy%=ao%(ca%,i%,2)
1230   if ot%=1 then 1250
1231   if ot%=2 then 1260
1235   goto 1298

1250   ' step-on object
1251   if px%=ox% and py%=oy% then 1296
1252   goto 1298

1260 ' prompt object
1261 if abs(px%-ox%) <= 1 and abs(py%-oy%) <=1 then no%=i%:return
1262 goto 1298

1296   a1%=i%
1297   gosub 1300
1298 next i%
1299 return

1300 ' call object callback
1301 on ao%(ca%,a1%,3) gosub 5000, 5100, 5200
1302 return

2000 ' initialize area
2010 cls
2020 gosub 1000 
2030 nx%=as%(ca%,0)
2031 px%=nx%
2040 ny%=as%(ca%,1)
2041 py%=ny%
2050 gosub 1100
2090 return

3000 ' input handling
3010 in$=inkey$
3020 if in$="" then 3099
3021 qx%=px%
3022 qy%=py%
3024 in%=asc(in$)
3030 if in%=13 and co%<>-1 then a1%=co%:gosub 1300:return
3031 if (in%=31 or in%=115) and ny%<6 then 3040
3032 if (in%=30 or in%=119) and ny%>0 then 3050
3033 if (in%=28 or in%=100) and nx%<19 then 3060
3034 if (in%=29 or in%=97) and nx%>0 then 3070
3039 goto 3099
3040 qy%=qy%+1
3041 goto 3080
3050 qy%=qy%-1
3051 goto 3080
3060 qx%=qx%+1
3061 goto 3080
3070 qx%=qx%-1
3071 goto 3080
3080 tc$=mid$(ad$(ca%,qy%), qx% + 1, 1)
3081 if tc$<>" " then 3099
3082 nx%=qx%
3083 ny%=qy%
3099 return

5000 ' area 0 door 0
5001 ca%=1
5002 return

5100 ' a1o0
5101 ca%=0
5102 as%(0,0)=18
5103 as%(0,1)=5
5104 return

5200 ' a0o1
5201 nf%=0
5202 gosub 10050
5205 return

10000 ' init dialog system
10001 dim df%(10,4)
10002 dim ds$(10)
10003 dim do%(40,3)
10004 dim dp$(40)
10005 cf%=-1
10006 co%=-1
10007 nf%=-1
10008 oc%=0
10009 cp%=0
10019 return

10050 ' dialog sub-proc
10060 if nf%<>cf% then cf%=nf%:gosub 10090
10061 if cf%=-1 then return
10062 gosub 10200
10070 cf%=-1
10071 nf%=-1
10072 return

10090 ' render dialog frame
10091 gosub 1150
10092 print @20, ds$(cf%)
10093 pl%=4
10094 for i%=0 to 3 step 1
10095   oi%=df%(cf%,i%)
10096   if oi%=0 then 10111
10097   print @(pl%*40)+22,dp$(oi%);
10098   pl%=pl%+1
10110 next i%
10111 oc%=i%-1
10112 cp%=0
10120 return

10200 ' render dialog option selection
10210 for i%=7 to 7 step 1
10220   print @(i%*40)+21," ";
10230 next i%
10240 print @((cp%+4)*40)+21, "�";
10250 return

25000 ' init game data
25010 ds$(0)="Hello!
25011 dp$(1)="Hi!"
25012 df%(0,0)=1
25013 dp$(2)="Goodbye"
25014 df%(0,1)=2

31500 return
