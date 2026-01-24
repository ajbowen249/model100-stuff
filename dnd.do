0 ' M100 BASIC DND

0 ' subroutine i/o
0 ' use sparingly; there is no arg
0 ' or return stack ("sub" not "func")

1 a1%=0
2 a1$=""

10 o1%=0
11 o1$=""
12 dim o1$(10)

100 ' exploration system
101 dim ad$(2,8)
102 dim as%(2,2)
103 dim ao%(2,5,4)
104 dim ap$(2,5)

110 ca%=0
111 px%=0
112 py%=0
113 ex%=0
114 la%=-1
115 nx%=-1
116 ny%=-1
117 co%=-1
118 no%=-1

797 gosub 10000
798 gosub 25000
799 goto 900

850 gosub 2000
851 la%=ca%

900 ' main loop
901 if la% <> ca% then goto 850
910 gosub 3000
911 if nx%<>px% or ny%<>py% then gosub 1100:gosub 1200
912 if no%<>co% then co%=no%:gosub 1150:gosub 1170
999 goto 900

1000 ' render current area
1010 for i%=0 to 7 step 1
1020   print ad$(ca%, i%);
1021   if i%<7 then print ""
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
1152   print @(i%*40)+20, space$(20);
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
3031 if (in%=31 or in%=115) and ny%<7 then 3040
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
5103 as%(0,1)=6
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
10010 np%=0
10019 return

10050 ' dialog sub-proc
10060 if nf%<>cf% and nf%<>-1 then cf%=nf%:gosub 10090:cp%=-1:np%=0
10061 if cf%=-1 then return
10062 if cp%<>np% then cp%=np%:gosub 10200
10063 in$=inkey$
10064 if in$="" then goto 10063
10065 in%=asc(in$)
10066 if (in%=115 or in%= 31) and cp%<oc%  then np%=cp%+1
10067 if (in%=119 or in%= 30) and cp%>0 then np%=cp%-1
10089 goto 10050

10090 ' render dialog frame
10091 gosub 1150
10092 a1%=20
10093 a1$=ds$(cf%)
10094 gosub 10300
10095 for i%=0 to o1%-1 step 1
10096   print @(i*40)+20,o1$(i%)
10097 next i%

10173 pl%=4
10174 for i%=0 to 3 step 1
10175   oi%=df%(cf%,i%)
10176   if oi%=0 then 10181
10177   print @(pl%*40)+22,dp$(oi%);
10178   pl%=pl%+1
10180 next i%
10181 oc%=i%-1
10182 cp%=0
10190 return

10200 ' render dialog option selection
10210 for i%=4 to 7 step 1
10220   print @(i%*40)+21," ";
10230 next i%
10240 print @((cp%+4)*40)+21, "Э";
10250 return

10300 ' wrap string
10301 o1%=0:si%=0
10302 ni%=instr(si%+1,a1$," ")
10303 if ni%=0 then o1$(o1%)=a1$:o1%=o1%+1:return
10304 if ni%>=a1% then o1$(o1%)=left$(a1$,ni%):a1$=right$(a1$,len(a1$)-ni%):o1%=o1%+1
10309 si%=ni%
10310 goto 10302

25000 ' init game data

25001 ' рстуфхцчшщъ
25010 ad$(0,0)="рсссссссссссссссссст"
25011 ad$(0,1)="х                  х"
25012 ad$(0,2)="х  х               х"
25013 ad$(0,3)="х със      Ф       х"
25014 ad$(0,4)="х  х               х"
25015 ad$(0,5)="х                  х"
25016 ad$(0,6)="х                   "
25017 ad$(0,7)="цссссссссссссссссссч"
25020 as%(0,0)=7
25021 as%(0,1)=3
25023 ao%(0,0,0)=1
25024 ao%(0,0,1)=19
25025 ao%(0,0,2)=6
25026 ao%(0,0,3)=1
25030 ao%(0,1,0)=2
25031 ao%(0,1,1)=11
25032 ao%(0,1,2)=3
25033 ao%(0,1,3)=3
25034 ap$(0,1)="Talk"

25040 ds$(0)="Hello. It's kinda like DDE, but in BASIC!"
25041 dp$(1)="Hi!"
25042 df%(0,0)=1
25043 dp$(2)="Goodbye"
25044 df%(0,1)=2

25100 ad$(1,0)="рсссссссссссссссссст"
25101 ad$(1,1)="х                  х"
25102 ad$(1,2)="х                  х"
25103 ad$(1,3)="х                  х"
25104 ad$(1,4)="х      рсст        х"
25105 ad$(1,5)="х         х        х"
25106 ad$(1,6)="       х  х        х"
25107 ad$(1,7)="цссссссшссшссссссссч"
25110 as%(1,0)=1
25111 as%(1,1)=6
25112 ao%(1,0,0)=1
25116 ao%(1,0,1)=0
25117 ao%(1,0,2)=6
25118 ao%(1,0,3)=2

31500 return
