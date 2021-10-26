#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บ Autor ณ PAULO BINOD        บ Data ณ  06/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA PARA CONTROLE DE ABASTECIMENTO DA FABRICA             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ACDAT004()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local cListBox
	Local nOpc		:= 0
	Local nF4For
	Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local lCampos 	:= .F.
	Local cOP	:= Space(Len(CBH->CBH_OP))

	Private oListBox,o1ListBox,o2ListBox
	Private oDlgNotas
	Private cCrono		:= "00:00"							// Cronometro da ligacao atual
	Private oCrono					            			// Objeto da tela "00:00"
	Private cTimeOut		:= "00:00"                        	// Time out do atendimento (Posto de venda)
	Private nTimeSeg		:= 0                      			// Segundos do cronograma
	Private nTimeMin		:= 0                      			// Minutos do cronograma
	Private oFnt1			:= TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro
	Private oLocal
	Private nSeconds	:= 18000
	Private aOPs := {}		// PRODUTOS POR OP
	Private a2OPs := {}		// LISTA DE OPS
	Private a2ItOPs := {}	// ITENS OPS
	Private aStatus	:= {}	//STATUS DAS OPS

	Private aOnda := {}		//ONDAS EM ABERTO
	Private aAtraso := {}	//PEDIDOS IMPRESSOS E NAO FATURADOS
	Private nNotasF := 0	//NOTAS FATURA
	Private nNotasR := 0	//NOTAS REMESSA
	Private nValF	:= 0	//TOTAL FATURA
	Private nValR	:= 0	//TOTAL REMESSA
	Private nItensS := 0	//SOMA DOS ITENS FATURADOS
	Private nItensD := 0	//ITENS DISTINTOS
	Private l20 	:= .F.
	Private cArmOri	:= "02"	//ARMAZEM DE SEPARACAO


	Cursorwait()
	RelerTerm()
	CursorArrow()

	//MONTA A TELA PEDIDOS SEM ONDA/IMPRESSOS
	cFields := " "
	nCampo 	:= 0

	//aStatus {01-COR, 02- DESCR, 03- TOTAL}
	aTitCampos := {'',OemToAnsi("Situa็ใo"),OemToAnsi("Qtde.Ops")}

	cLine := "{aStatus[oListBox:nAT][1],aStatus[oListBox:nAT][2],aStatus[oListBox:nAT][3],}"

	bLine := &( "{ || " + cLine + " }" )

	@100,005 TO 600,950  DIALOG oDlgNotas TITLE "Controle Abastecimento"
	@ 5,2 TO 70,135 LABEL "OPs sem geracao" OF oDlgNotas  PIXEL
	oListBox := TWBrowse():New( 17,4,130,50,,aTitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aStatus)
	oListBox:bLDblClick := { ||Processa( {||WSAT02B(aStatus[oListBox:nAT][2]) }) }
	oListBox:bLine := bLine


	//MONTA TELA ONDA
	c1Fields := " "
	n1Campo 	:= 0

	//01- COR ,02- ONDA, 03- DATA, 04- OPS, 05- TOTAL ITENS, 06- '', 07- FALTA SEPARACAO, 08- '', 09- '', 10- '',11-'', 12-TRAVA, 13 -'', 14 - NOME ONDA, 15-ENDERECO
	a1TitCampos := {'',OemToAnsi("Onda"),OemToAnsi("Data Gera็ใo"),OemToAnsi("Nome Onda"),OemToAnsi("Qtde.OPs"),OemToAnsi("Total Itens)"),OemToAnsi("F.Separar"),OemToAnsi("Trava Sep."),''}

	c1Line := "{aOnda[o1ListBox:nAT][1],aOnda[o1ListBox:nAT][2],aOnda[o1ListBox:nAT][3],aOnda[o1ListBox:nAT][14],aOnda[o1ListBox:nAT][4],aOnda[o1ListBox:nAT][5],aOnda[o1ListBox:nAT][7],aOnda[o1ListBox:nAT][12],}"

	b1Line := &( "{ || " + c1Line + " }" )
	nMult := 7
	aCoord := {nMult*1,nMult*6,nMult*8,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*8,nMult*12,nMult*2,''}


	@ 72,2 TO 185,460 LABEL "Status Onda/OPs" OF oDlgNotas  PIXEL
	o1ListBox := TWBrowse():New( 80,4,450,080,,a1TitCampos,aCoord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o1ListBox:SetArray(aOnda)
	o1ListBox:bLDblClick := { ||Processa( {||WSAT02A(aOnda[o1ListBox:nAt,2]) }) }
	o1ListBox:bLine := b1Line

	@ 165, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 015 SAY "Gerada no dia" OF oDlgNotas Color CLR_GREEN PIXEL

	@ 165, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 095 SAY "Atraso" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 005 BITMAP oBmp3 ResName 	"BR_PRETO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 015 SAY "Encerrada" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 080 BITMAP oBmp4 ResName 	"BR_AZUL" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 095 SAY "Travada" OF oDlgNotas Color CLR_RED PIXEL

	//busca de OPs
	@ 172,130 Say OemToAnsi("OP") Size 99,6 Of oDlgNotas Pixel
	@ 172,180 MSGet cOP Picture "@!" Size 59,8 Of oDlgNotas Pixel

	@ 172,389 BUTTON "Busca"   	SIZE 20,10 ACTION (ACDAT4ABAST(cOP),cOP:= Space(Len(CBH->CBH_OP)),oDlgNotas:Refresh()) PIXEL OF oDlgNotas


	//MONTA A TELA PEDIDOS IMPRESSOS/ONDA ATRASADOS
	c2Fields := " "
	n2Campo 	:= 0

	//01- STATUS, 02-DATA, 03-QTDE PEDIDOS
	a2TitCampos := {OemToAnsi("Status"),OemToAnsi("Data"),OemToAnsi("Qtde.Pedidos"),''}

	c2Line := "{aAtraso[o2ListBox:nAT][1],aAtraso[o2ListBox:nAT][2],aAtraso[o2ListBox:nAT][3],aAtraso[o2ListBox:nAT][4]}"

	b2Line := &( "{ || " + c2Line + " }" )
	/*
	@ 5,145 TO 70,390 LABEL "Pedidos Impressos/Onda em atraso no CD" OF oDlgNotas  PIXEL
	o2ListBox := TWBrowse():New( 17,150,230,50,,a2TitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o2ListBox:SetArray(aAtraso)
	//o2ListBox:bLDblClick := { || MarcaTodos(o2ListBox, .T., .T.,1,o2ListBox:nAt) }
	o2ListBox:bLine := b2Line
	*/
	@ 015,430  SAY oCrono VAR cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgNotas


	dbSelectArea("SM0")
	//	If U_CHECAFUNC(RetCodUsr(),"WMSAT002") .Or. cFilAnt # "02"
	//--@ 210,005 BUTTON "Gerar Onda"    	SIZE 40,15 ACTION (U_ACDRD001(),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	@ 210,050 BUTTON "Gera OP"		   	SIZE 40,15 ACTION ( U_PCPRD003()) PIXEL OF oDlgNotas
	//--@ 210,095 BUTTON "Estorna Sep."		SIZE 40,15 ACTION {Processa( {|| WSAT2EST("2") } ),nOpc :=1,oDlgNotas:End()} PIXEL OF oDlgNotas
	//--@ 210,140 BUTTON "Cancelar Onda"	SIZE 40,15 ACTION {Processa( {|| WSAT2EST("1") } ),nOpc :=1,oDlgNotas:End()} PIXEL OF oDlgNotas

	//--@ 210,185 BUTTON "Status Apont."	SIZE 40,15 ACTION {Processa( {|| ACDAT4APONT() } )} PIXEL OF oDlgNotas
	//--@ 210,230 BUTTON "Status Abast."	SIZE 40,15 ACTION (Processa( {|| ACDAT4ABAST(cOp) } )) PIXEL OF oDlgNotas
	//		@ 210,230 BUTTON "Risca FDE"		SIZE 40,15 ACTION (Processa( {||MsgStop("ROTINA DESABILITADA")})) PIXEL OF oDlgNotas
	//		@ 210,275 BUTTON "Prev.Pedidos"		SIZE 40,15 ACTION (Processa( {||U_PedidosCD()})) PIXEL OF oDlgNotas
	//	@ 210,320 BUTTON "Risca Item"		SIZE 40,15 ACTION (U_RiscaItem()) PIXEL OF oDlgNotas
	//--@ 210,365 BUTTON "Lib./Trav" 		SIZE 40,15 ACTION {U_LibOnda(aOnda[o1ListBox:nAt,2],"S",aOnda[o1ListBox:nAt,12])} PIXEL OF oDlgNotas
	//		@ 210,410 BUTTON "Lib./Trav.Pre." 		SIZE 40,15 ACTION {U_LibOnda(aOnda[o1ListBox:nAt,2],"P",aOnda[o1ListBox:nAt,12])} PIXEL OF oDlgNotas

	//--@ 230,005 BUTTON "Atualizar"    	SIZE 40,15 ACTION {WSAT2AtuCro(2)} PIXEL OF oDlgNotas
	//		@ 230,050 BUTTON "Rel.Abastec."		SIZE 40,15 ACTION (U_WS02ABAST()) PIXEL OF oDlgNotas
	//	EndIf

	//--@ 230,095 BUTTON "Acomp.Separ." 	SIZE 40,15 ACTION {U_WMACOMP(aOnda[o1ListBox:nAt,2])} PIXEL OF oDlgNotas
	//	@ 230,140 BUTTON "Acomp.Pre." 		SIZE 40,15 ACTION {U_WMSPCACOMP(aOnda[o1ListBox:nAt,2],"P")} PIXEL OF oDlgNotas
	//	@ 230,185 BUTTON "Acomp.Chk." 		SIZE 40,15 ACTION {U_WMSPCACOMP(aOnda[o1ListBox:nAt,2],"C")} PIXEL OF oDlgNotas
	//--@ 230,230 BUTTON "Rel.Produt." 		SIZE 40,15 ACTION {U_WMSRL001()} PIXEL OF oDlgNotas
	//--@ 230,275 BUTTON "Etiquetas OP" 		SIZE 40,15 ACTION {U_RACD002()} PIXEL OF oDlgNotas
	//	@ 230,275 BUTTON "Rel.Sobra." 		SIZE 40,15 ACTION {U_WSAT02SB(aOnda[o1ListBox:nAt,2]),oDlgNotas:Refresh()} PIXEL OF oDlgNotas
	//	@ 230,320 BUTTON "ALERTA"	 		SIZE 40,15 ACTION {U_ALERTAONDA()} PIXEL OF oDlgNotas

	//If U_CHECAFUNC(RetCodUsr(),"WMSAT002") .Or. cFilAnt # "02"
	//--@ 230,365 BUTTON "Libera Trava" 	SIZE 40,15 ACTION {PutMv("MV__ACDRD1","N")} PIXEL OF oDlgNotas
	//EndIf
	@ 230,410 BUTTON "Sair"        		SIZE 40,15 ACTION {nOpc :=0,oDlgNotas:End()} PIXEL OF oDlgNotas



	oTimer := TTimer():New( 10 * 1000, {||WSAT2AtuCro(1)  }, oDlgNotas )
	oTimer:lActive   := .T. // para ativar

	ACTIVATE DIALOG oDlgNotas CENTERED


	If nOpc == 1
		U_ACDAT004()
	EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function RelerTerm()
	Local nAscan := 0
	Local KK	 := 0

	dData 	:= dDataBase
	If Dow(dData+2) == 1 //CAIR NO DOMINGO
		dData += 4
	ElseIf Dow(dData+2) = 7 //CAIR NO SABADO
		dData += 3
	Else
		dData += 2
	End


	//ZERA O CRONOMETRO
	nTimeMin := 0
	nTimeSeg := 0
	cTimeAtu := "00:00"



	//SELECIONA AS OPS COM EMPENHO
	cQuery := " SELECT D4_OP,  D4_COD, B1_DESC, SUM(D4_QUANT) AS QTDEMP , COUNT(DISTINCT(D4_OP)) OPS,C2_DATPRI, C2_PRODUTO,C2__RECURS,
	cQuery += " ISNULL((SELECT B2_QATU-B2_QACLASS-(SELECT SUM(BF_EMPENHO) FROM "+RetSqlName("SBF")+" WITH(NOLOCK) WHERE BF_FILIAL = B2_FILIAL AND BF_PRODUTO = B2_COD AND BF_LOCAL = B2_LOCAL AND D_E_L_E_T_ <> '*' ) FROM "+RetSqlName("SB2")+" WITH(NOLOCK) WHERE B2_COD = D4_COD AND D_E_L_E_T_ <> '*' AND B2_LOCAL = '02' AND B2_FILIAL = D4_FILIAL ),0) AS SALDO_DISPO,
	cQuery += " ISNULL((SELECT B2_QACLASS FROM "+RetSqlName("SB2")+" WITH(NOLOCK) WHERE D4_FILIAL = B2_FILIAL AND B2_COD = D4_COD AND D_E_L_E_T_ <> '*' AND B2_LOCAL = '02' ),0) AS SALDO_CLASS,
	cQuery += " ISNULL((SELECT SUM(D7_SALDO) FROM "+RetSqlName("SD7")+" WITH(NOLOCK) WHERE D7_PRODUTO = D4_COD AND  D_E_L_E_T_ <> '*' AND D7_ESTORNO = '' AND D7_LIBERA = ''  ),0) AS SALDO_CQ
	cQuery += " FROM "+RetSqlName("SC2")+" C2 WITH(NOLOCK)
	cQuery += " INNER JOIN "+RetSqlName("SD4")+" D4 WITH(NOLOCK) ON C2_FILIAL = D4_FILIAL AND C2_NUM+C2_ITEM+C2_SEQUEN = RTRIM(D4_OP)
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = D4_COD AND B1_FILIAL = D4_FILIAL 
	cQuery += " WHERE
	cQuery += " C2_DATRF = '' 
	cQuery += " AND C2_TPOP = 'F'
	cQuery += " AND C2.D_E_L_E_T_ <> '*' AND D4.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'
	cQuery += " AND C2_QUANT > (C2_QUJE+C2_PERDA)
	cQuery += " AND D4_QUANT > 0
	cQuery += " AND B1_APROPRI = 'D' 
	//deixar A EXCLUSAO DOS CODIGOS, provisorio ate separar os almoxarifados
	cQuery += " AND B1_COD NOT IN ('623150035','617060025','617060067','617060068','623000463','623000879','623050462','623050876','623100585','623150000','623150001','623150002','623150005','623150007','623150011','623150016','623150018','623150019','623150033','623150034','623260059','623300000','623300001','625200018','960100001','960100007','960902400','625000246','625000286','625000606','625000609','625000671','625000706','625000707','625000708','625000709','625000710','625000711','625000712','625000713','625000714','625000715','625000716','625000717','625000718','625000719','625000720','625000721','625000722','625000723','625000724','625000725','625000726',
	cQuery += " '625000727','625000728','625000729','625000730','625000733','625000734','625000735','625000736','625000737','625000738','625000739','625000740','625000741','625000742','625000743','625000744','625000745','625000746','625000747','625000750','625000751','625000757','625000768','625000769','625000787','625000790','625000791','625000792','625000793','625000797','625050260','625050332','625050333','625050335','625050336','625050337','625050338','625050341','625050342','625050344','625050345','625050349','625050354','625050355','625050356','625050357','625050358','625050360','625050361','625050362','625050363','625050372','625050374','625050379',
	cQuery += " '625050380','625050381','625050386','625050391','625050393','625050394','625050395','625050396','625100074','625100080','625100280','625100281','625100282','625100283','625100284','625100285','625100286','625100293','625100294','625100296','625100297','606020004','606020006','606020007','960000015','625050401','625000814','625000815','625100221','625000815','625000816','625050364','625000818','625000843','625000834','625000840','625000825','625000826','625000827','625000828','625000829','625000830','625000831','625000832','625000833','625000835','625000836','625000837','625000838','625000839','625000841','625000842','625000843','625000852')
	cQuery += " AND B1_TIPO NOT IN ('MO')
	cQuery += " AND C2_ORDSEP = ''
	cQuery += " GROUP BY D4_OP,D4_COD,B1_DESC, C2_DATPRI,C2_PRODUTO,C2__RECURS , D4_FILIAL
	cQuery += " ORDER BY D4_OP, D4_COD 

	MemoWrite("WMSAT002C.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	TcSetField('TRB','C2_DATPRI','D')


	Count To nRec1

	aOPs 	:= {}
	a2OPs 	:= {}
	a2ItOPs := {}
	aStatus	:= {}

	If nRec1 == 0
		//a2ItOPs {01-COR, 02-OP, 03-COD PROD, 04-DESCRICAO, 05-QTDEMP, 06-QTDE OPS, 07-SALDO DISP., 08-SALDO CLASS.,09-SALDO CQ,10-LSEPARA}
		aAdd(a2ItOPs,{'','','','',0,0,0,0,0,.F.})
		//AOPS {01-COR, 02-SITUACAO, 03-QTDE OPS, 04- COD PROD OP, 05- RECURSO}
		aAdd(aOPs,{'','',0,'',''})
		//a2OPs{01-PRODUTO, 02-EMPENHO, 03-DISPONIBILIDADE, 04-SALDO UTILIZADO}
		aAdd(a2OPs,{'',0,0,0,0})
	Else

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()


			//MONTA COR DAS OPS ATENDIDAS
			If TRB->SALDO_DISPO >= TRB->QTDEMP //TOTAL
				cBitMap := LoadBitMap(GetResources(),"BR_VERDE"    )
				cStatus := 'T'	
			ElseIf TRB->SALDO_DISPO > 0 //PARCIAL
				cBitMap := LoadBitMap(GetResources(),"BR_AMARELO"  )
				cStatus := 'P'
			Else //SEM SALDO
				cBitMap := LoadBitMap(GetResources(),"BR_VERMELHO" )
				cStatus := 'F'	
			EndIf
			//a2ItOPs {01-COR, 02-OP, 03-COD PROD, 04-DESCRICAO, 05-QTDEMP, 06-QTDE OPS, 07-SALDO DISP., 08-SALDO CLASS.,09-SALDO CQ,10-LSEPARA}
			aAdd(a2ItOPs,{cBitMap,TRB->D4_OP,TRB->D4_COD,TRB->B1_DESC,TRB->QTDEMP,TRB->OPS,TRB->SALDO_DISPO,TRB->SALDO_CLASS,TRB->SALDO_CQ,.F.})

			//a2OPs{01-PRODUTO, 02-EMPENHO, 03-DISPONIBILIDADE, 04-SALDO UTILIZADO}
			nAscan := Ascan(a2OPs, {|e| e[1] == TRB->D4_COD })
			If nAscan == 0
				aAdd(a2OPS,{TRB->D4_COD,TRB->QTDEMP,TRB->SALDO_DISPO, 0})
			Else
				a2OPS[nAscan][2] += TRB->QTDEMP				
			EndIf 


			//MONTA ARRAY OPS
			//aOPs {01-OP, 02-STATUS, 03- DT INICIAL, 04-COD PROD OP, 05 - RECURSO}
			nAscan := Ascan(aOPs, {|e| e[1] == TRB->D4_OP })
			cStatus := Iif(cStatus=='T','Atendido',Iif(cStatus=='P','Parcial','Faltas'))

			If nAscan == 0
				aAdd(aOPS,{TRB->D4_OP, cStatus, TRB->C2_DATPRI,TRB->C2_PRODUTO,TRB->C2__RECURS})
			Else
				If aOPs[nAscan][2] == 'Atendido' .And. cStatus == 'Parcial'
					aOPs[nAscan][2] := 'Parcial'
				ElseIf  cStatus == 'Faltas'
					aOPs[nAscan][2] := 'Faltas'
				EndIf		
			EndIf 
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())

	//MONTA STATUS DAS OPS
	For kk:=1 To Len(aOPs)
		nAscan := Ascan(aStatus, {|e| e[2] == aOPs[kk][2] })

		If nAscan == 0
			If aOPs[kk][2] == 'Atendido'
				cBitMap := LoadBitMap(GetResources(),"BR_VERDE"    )				
			ElseIf aOPs[kk][2] == 'Parcial'
				cBitMap := LoadBitMap(GetResources(),"BR_AMARELO"  )			
			Else //SEM SALDO
				cBitMap := LoadBitMap(GetResources(),"BR_VERMELHO" )
			EndIf

			//aStatus {01-COR, 02- DESCR, 03- TOTAL}
			aAdd(aStatus,{cBitMap,aOPs[kk][2],1})
		Else
			aStatus[nAscan][3] ++
		EndIf 


	Next

	//SELECIONA A SITUACAO DA ONDAS EM ABERTO
	cQuery := " select "
	If l20
		cQuery += " TOP 20 "
	EndIf
	cQuery += " CB7_DTEMIS ,CB7__PRESE, CB7__NOME, ISNULL(SUM(CB8_QTDORI),0) TOTAL_PECAS,
	cQuery += " (SELECT COUNT(CB72.CB7_OP) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_CODOPE  = '' AND CB72.CB7_OP <> '')  OP_AFAZER,
	cQuery += " (SELECT COUNT(C2_NUM+C2_ITEM+C2_SEQUEN) FROM "+RetSqlName("SC2")+" WHERE C2_NUM+C2_ITEM+C2_SEQUEN=CB7_OP AND D_E_L_E_T_ <> '*' AND C2_DATRF = '') OP_PRODUZIR ,
	cQuery += " COUNT(DISTINCT(CB8_PROD)) TOTAL_ITENS, 
	cQuery += " COUNT(DISTINCT(CB7_OP)) OPS, 
	cQuery += " COUNT(CB8_PROD) ITENS_PRE_CHECKOUT, 
	cQuery += " (SELECT count(CB8_PROD) FROM CB8040 CB82 WITH(NOLOCK)
	cQuery += " INNER JOIN "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) ON CB72.CB7_FILIAL = CB82.CB8_FILIAL AND CB72.CB7_ORDSEP = CB82.CB8_ORDSEP
	cQuery += " WHERE CB72.D_E_L_E_T_ <> '*' AND CB82.D_E_L_E_T_ <> '*' AND CB72.CB7_OP <> '' AND CB72.CB7__PRESE = CB7.CB7__PRESE AND CB8_SALDOS > 0) ITENS_SEPARACAO,
	cQuery += " CB7__TRAVA, CB7_OP
	cQuery += " FROM "+RetSqlName("CB7")+" CB7 WITH(NOLOCK)
	cQuery += " LEFT JOIN "+RetSqlName("CB8")+ " CB8 WITH(NOLOCK) ON CB7_FILIAL = CB8_FILIAL AND CB7_ORDSEP = CB8_ORDSEP AND CB8.D_E_L_E_T_ <> '*'
	cQuery += " WHERE CB7.D_E_L_E_T_ <> '*'  AND CB7_OP <> ''
	cQuery += " AND CB7_FILIAL = '"+xFilial("CB7")+"'"
	cQuery += " AND CB7_DTEMIS >= '"+Dtos(dDataBase-30)+"'"
	cQuery += " GROUP BY CB7_DTEMIS ,CB7__PRESE, CB7__NOME, CB7_FILIAL,CB7__TRAVA, CB7_OP

	//EM ITU MOSTRA AS ULTIMAS ONDAS
	If !l20
		cQuery += " HAVING ( SELECT COUNT(DISTINCT(CB72.CB7_OP)) FROM "+RetSqlName("CB7")+" CB72 WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE = CB7.CB7__PRESE AND CB72.CB7_OP <> '' 
		cQuery += " AND CB7_OP IN (SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM "+RetSqlName("SC2")+" WHERE C2_NUM+C2_ITEM+C2_SEQUEN=CB72.CB7_OP AND D_E_L_E_T_ <> '*'  AND C2_QUJE < C2_QUANT AND C2_DATRF = '')) > 0
	EndIf

	cQuery += " ORDER BY CB7__PRESE DESC"
	CONOUT("SELECIONA A SITUACAO DA ONDAS EM ABERTO")

	MemoWrite("WMSAT002E.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	TcSetField("TRB","CB7_DTEMIS","D")

	Count To nRec1
	CursorArrow()
	aOnda := {}
	If nRec1 == 0
		//01- COR ,02- ONDA, 03- DATA, 04- OPS, 05- TOTAL ITENS, 06- '', 07- FALTA SEPARACAO, 08- '', 09- '', 10- '',11-'', 12-TRAVA, 13 -'', 14 - NOME ONDA	
		aAdd(aOnda,{'',"",cTod(""),0,0,0,0,0,0,0,0,'','',''})
	Else
		dbSelectArea("TRB")
		ProcRegua(nRec1)
		dbGotop()

		While !Eof()
			nAscan := Ascan(aOnda, {|e| e[2] == TRB->CB7__PRESE })
			If nAscan == 0
				IncProc("Calculado as Ondas")
				cCor := Iif(TRB->CB7_DTEMIS==dDataBase,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_VERMELHO"))
				cCor := Iif(TRB->CB7__TRAVA = "S",LoadBitMap(GetResources(),"BR_AZUL"),cCor)
				//01- COR ,02- ONDA      , 03- DATA    , 04- OPS , 05- TOTAL ITENS, 06- '', 07- FALTA SEPARACAO, 08- '', 09- '', 10- '',11-'', 12-TRAVA      , 13 -'', 14 - NOME ONDA
				aAdd(aOnda,{cCor,TRB->CB7__PRESE,TRB->CB7_DTEMIS,TRB->OPS,TRB->TOTAL_ITENS, 0     ,TRB->ITENS_SEPARACAO, 0     , 0     , 0     , 0   ,TRB->CB7__TRAVA, ''    ,TRB->CB7__NOME})
			Else
				aOnda[nAscan][4] += TRB->OPS
				aOnda[nAscan][5] += TRB->TOTAL_ITENS
			EndIf
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())

	ASort(aOnda,,,{|x,y|x[2]<y[2]})

return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function WSAT2AtuCro(nTipo)
	Local cTimeAtu := ""

	cTimeOut := "15:00"

	nTimeSeg += 10

	If nTimeSeg > 59
		nTimeMin ++
		nTimeSeg := 0
		If nTimeMin > 60
			nTimeMin := 0
		Endif
	Endif

	cTimeAtu := STRZERO(nTimeMin,2,0)+":"+STRZERO(nTimeSeg,2,0)

	If cTimeAtu >= cTimeOut
		oCrono:nClrText := CLR_RED
		oCrono:Refresh()
	Endif

	If cTimeAtu >= "14:30" .Or. nTipo == 2
		oDlgNotas:End()
		U_ACDAT004()

	EndIf

	cCrono := cTimeAtu
	oCrono:Refresh()


Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSAT2EST  บAutor  ณMicrosiga           บ Data ณ  03/22/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณESTORNA UMA ONDA                                            บฑฑ
ฑฑบ          ณ OPC 1 ONDA - 2-OP                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSAT2EST(cOpcEst)
	Local cOnda := Space(06)
	Local cOP 	:= Space(13)
	Local lExclui := .T.
	Local cUsuLib
	Local aTravas := {}
	Local dValid    := Ctod("")	
	Local nNoArray	:= 0
	PRIVATE lMsErroAuto := .F.
	Private aItens	:= {}

	dbSelectArea("SM0")
	cUsuLib := RetCodUsr()

	If MsgYesNo("Deseja cancelar a "+Iif(cOpcEst =="1","Onda","OP")+" ?","ACDAT004")

		If cOpcEst == "1" //ONDA
			@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Cancelamento de Onda")
			@ 9,9 Say OemToAnsi("Onda") Size 99,8 PIXEL OF oDlg
			@ 28,9 Get cOnda Picture "@!" F3 "CB7" Size 59,10
			@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
			Activate Dialog oDlg Centered
		Else //OP
			@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Cancelamento de OP")
			@ 9,9 Say OemToAnsi("OP") Size 99,8 PIXEL OF oDlg
			@ 28,9 Get cOP Picture "@!" F3 "SC2" Size 59,10
			@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
			Activate Dialog oDlg Centered

		EndIf

		If !Empty(cOnda) .Or. !Empty(cOP)
			//VERIFICA SE A ONDA PODE SER APAGADA
			cQuery := " SELECT * FROM "+RetSqlName("CB9")+" WITH(NOLOCK)"
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB9_FILIAL = '"+xFilial("CB9")+"' AND CB9_ORDSEP IN
			cQuery += " (SELECT CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK)
			If cOpcEst == "1" 
				cQuery += " WHERE CB7__PRESE = '"+cOnda+"'
			Else
				cQuery += " WHERE CB7_OP = '"+cOP+"'
			EndIf 
			cQuery += " AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = CB9_FILIAL )"

			MEMOWRITE("WSAT2EST.SQL",cQuery)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

			Count To nRec

			If nRec > 0
				If cOpcEst == "1" 
					MsgStop("Esta Onda Jแ possui movimentacao!","ACDAT004")
					TRB->(dbCloseArea())
					Return(.F.)
				Else
					If !MsgYesno("Esta OP ja foi separada, deseja estornar mesmo assim?","ACDAT004")
						TRB->(dbCloseArea())
						Return(.F.)
					EndIf

				EndIf 
			EndIf
			TRB->(dbCloseArea())

			Begin Transaction
				//ESTORNA AS LIBERACAOES
				cQuery := " SELECT * FROM "+RetSqlName("SD4")+" D4 WITH(NOLOCK)"
				cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D_E_L_E_T_ <> '*'"
				cQuery += " AND D4_OP IN"
				cQuery += " (SELECT CB7_OP FROM "+RetSqlName("CB7")+" WITH(NOLOCK)

				If cOpcEst == "1" 
					cQuery += " WHERE CB7__PRESE = '"+cOnda+"'
				Else
					cQuery += " WHERE CB7_OP = '"+cOP+"'
				EndIf

				cQuery += " AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = D4_FILIAL  AND CB7_OP <> '')"

				MemoWrite("WSAT2EST1.SQL",cQuery)
				dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

				Count To nRec

				If nRec > 0
					ProcRegua(nRec)

					aItens		:= {}
					aLinha		:= {}
					cDocReq 	 := CriaVar('D3_DOC')
					aAdd(aItens,{cDocReq	,dDatabase})


					dbSelectArea("TRB")
					dbGoTop()

					While !Eof()
						IncProc("Estornando OPs Liberadas")
						//cArmOri := TRB->D4_LOCAL
						cNArmazem := "11"
						cNovaLcz  := "PROD"

						dbSelectArea("CB7")
						dbSetOrder(5)
						If dbSeek(xFilial()+TRB->D4_OP)
							cNovaLcz  := CB7->CB7__LCALI
						EndIf
						//ESTORNA TRANSFERENCIA DO 11 PARA O 02, E ESTORNA RESERVA NO 11
						dbSelectArea("SDC")
						dbSetOrder(2)
						If dbSeek(xFilial()+TRB->D4_COD+TRB->D4_LOCAL+TRB->D4_OP+TRB->D4_TRT+TRB->D4_LOTECTL+TRB->D4_NUMLOTE)
							cLote 		:= SDC->DC_LOTECTL
							nQuantDC 	:= SDC->DC_QUANT
							cLocalizDC	:= SDC->DC_LOCALIZ
							cTRT		:= SDC->DC_TRT


							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial()+TRB->D4_COD)

							If Rastro(SB1->B1_COD)
								SB8->(DbSetOrder(3))
								SB8->(DbSeek(xFilial("SB8")+SB1->B1_COD+SD4->D4_LOCAL+cLote+""))
								dValid := SB8->B8_DTVALID
							EndIf

							nNoArray:= Ascan(aItens,{|x| x[1] == SB1->B1_COD})
							If nNoArray != 0
								aItens[nNoArray,16] := aItens[nNoArray,16] + nQuantDC 
							Else
								//FAZ A TRANSFERENCIA
								aLinha:={}
								AADD(aLinha,SB1->B1_COD)
								AADD(aLinha,SB1->B1_DESC)
								AADD(aLinha,SB1->B1_UM)
								AADD(aLinha,TRB->D4_LOCAL)
								AADD(aLinha,cNovaLcz)
								AADD(aLinha,SB1->B1_COD)
								AADD(aLinha,SB1->B1_DESC)
								AADD(aLinha,SB1->B1_UM)
								AADD(aLinha,cArmOri)
								AADD(aLinha,"PROD")
								AADD(aLinha,'') //NUMSERI
								AADD(aLinha,cLote) //LOTECTL
								AADD(aLinha,'') //NUMLOTE
								AADD(aLinha,dValid) //DTVALID
								AADD(aLinha,0) //POTENCI
								AADD(aLinha,nQuantDC) //QUANT
								AADD(aLinha,0) //QTSEGUM
								AADD(aLinha,'') //ESTORNO
								AADD(aLinha,'') //NUMSEQ
								AADD(aLinha,cLote) //NUMLOTE
								AADD(aLinha,dValid) //DTVALID
								AADD(aLinha,'') // D3_ITEMGRD
								AADD(aLinha,'') // D3_IDDCF
								AADD(aLinha,'') // D3_OBSERVA
								AADD(aLinha,'') //  D3_OPTRANS
								AADD(aLinha,'') //  D3_NUM_PED

								AADD(aItens,aLinha)		
							EndIf

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Atualiza arquivo de empenhos               ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							U_ACDGravaEmp(TRB->D4_COD,;
							TRB->D4_LOCAL,;
							TRB->D4_QUANT,;
							TRB->D4_QTSEGUM,;
							TRB->D4_LOTECTL,;
							TRB->D4_NUMLOTE,;
							NIL,;
							NIL,;
							TRB->D4_OP,;
							TRB->D4_TRT,;
							NIL,;
							NIL,;
							"SC2",;
							TRB->D4_OPORIG,;
							TRB->D4_DATA,;
							@aTravas,;
							.T.,;		//CONTROLA INCLUSAO(.F.) OU ESTORNO(.T.)
							NIL,;
							NIL,;
							.T.,;		//GRAVA SD4
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							IIF(cPaisLoc=="BRA",TRB->D4_CODLAN,NIL))
						EndIf

						//ESTORNA EMPENHO DO ALMOXARIFADO 02 SE EXISTIR
						dbSelectArea("SDC")
						dbSetOrder(2)
						If dbSeek(xFilial()+TRB->D4_COD+"02"+TRB->D4_OP+TRB->D4_TRT+TRB->D4_LOTECTL+TRB->D4_NUMLOTE)
							cLote 		:= SDC->DC_LOTECTL
							nQuantDC 	:= SDC->DC_QUANT
							cLocalizDC	:= SDC->DC_LOCALIZ
							cTRT		:= SDC->DC_TRT


							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial()+TRB->D4_COD)

							If Rastro(SB1->B1_COD)
								SB8->(DbSetOrder(3))
								SB8->(DbSeek(xFilial("SB8")+SB1->B1_COD+cArmOri+cLote+""))
								dValid := SB8->B8_DTVALID
							EndIf

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Atualiza arquivo de empenhos               ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							U_ACDGravaEmp(TRB->D4_COD,;
							cArmOri,;
							TRB->D4_QUANT,;
							TRB->D4_QTSEGUM,;
							TRB->D4_LOTECTL,;
							TRB->D4_NUMLOTE,;
							NIL,;
							NIL,;
							TRB->D4_OP,;
							TRB->D4_TRT,;
							NIL,;
							NIL,;
							"SC2",;
							TRB->D4_OPORIG,;
							TRB->D4_DATA,;
							@aTravas,;
							.T.,;		//CONTROLA INCLUSAO(.F.) OU ESTORNO(.T.)
							NIL,;
							NIL,;
							.T.,;		//GRAVA SD4
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							IIF(cPaisLoc=="BRA",TRB->D4_CODLAN,NIL))

						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf
				TRB->(dbCloseArea())

				If Len(aItens) > 1
					lMsErroAuto := .F.
					lMsHelpAuto := .T.
					aCols      := {}
					aHeader    := {}

					MSExecAuto({|x,y| MATA261(x,y)},aItens,3) //inclui

					If lMsErroAuto
						MsgStop("Falha na gravacao da transferencia","ACDAT004") //###
						MostraErro()
						DisarmTransaction()
						Break
					EndIf
				EndIf

				//LIMPA OS STATUS DAS OPS
				cQuery := " SELECT CB7_FILIAL, CB7_OP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) "
				If cOpcEst == "1" 
					cQuery += " WHERE CB7__PRESE = '"+cOnda+"'
				Else
					cQuery += " WHERE CB7_OP = '"+cOP+"'
				EndIf
				cQuery += " AND D_E_L_E_T_ <> '*'  AND CB7_OP <> '' AND CB7_FILIAL  = '"+cFilAnt+"'"

				MemoWrite("WSAT2EST2.SQL",cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

				Count To nRec

				If nRec >0
					ProcRegua(nRec)
					IncProc("Liberando Status OPs")
					dbSelectArea("TRB")
					dbGoTop()
					While !Eof()
						dbSelectArea("SC2")
						dbSetOrder(1)
						If dbSeek(TRB->CB7_FILIAL+TRB->CB7_OP)
							RecLock("SC2",.F.)
							C2_ORDSEP := ''
							SC2->(MsUnlock())
						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf

				//DELETE AS ETIQUETAS NA CB0
				dbSelectArea("CB0")
				dbSetOrder(7)
				If dbSeek(xFilial()+TRB->CB7_OP)

					While !Eof() .And. TRB->CB7_OP ==CB0->CB0_OP
						RecLock('CB0',.f.)
						CB0->(DbDelete())
						CB0->(MSUnlock())
						dbSkip()
					End
				EndIf				
				TRB->(dbCloseArea())



				//LIMPA OS ITENS DA ONDA
				cQuery := " SELECT CB8_FILIAL, CB8_ORDSEP FROM "+RetSqlName("CB8")+" WITH(NOLOCK)"
				cQuery += " WHERE CB8_ORDSEP IN (SELECT CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL  AND CB7_ORDSEP = CB8_ORDSEP AND D_E_L_E_T_ <> '*' 

				If cOpcEst == "1" 
					cQuery += " AND CB7__PRESE = '"+cOnda+"')"
				Else
					cQuery += " AND CB7_OP = '"+cOP+"')"
				EndIf

				cQuery += " AND D_E_L_E_T_ <> '*' AND CB8_FILIAL  = '"+cFilAnt+"' "
				CONOUT("limpa os itens das OPS deletados do sistema CB8")

				MemoWrite("WSAT2EST2.SQL",cQuery)

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

				Count To nRec

				If nRec >0
					ProcRegua(nRec)
					dbSelectArea("TRB")
					dbGoTop()
					While !Eof()
						IncProc("Apagando itens onda")
						dbSelectArea("CB8")
						dbSetOrder(1)
						If dbSeek(TRB->CB8_FILIAL+TRB->CB8_ORDSEP)
							RecLock("CB8",.F.)
							dbDelete()
							CB8->(MsUnlock())
						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf
				TRB->(dbCloseArea())

				//LIMPA OS CABECALHOS DA ONDA
				cQuery := " SELECT CB7_FILIAL, CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK)"
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB7_FILIAL = '"+cFilAnt+"' 
				If cOpcEst == "1" 
					cQuery += " AND CB7__PRESE = '"+cOnda+"'
				Else
					cQuery += " AND CB7_OP = '"+cOP+"'"
				EndIf

				MemoWrite("WSAT2EST3.SQL",cQuery)
				CONOUT("limpa os cabecalhos da Onda")
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

				Count To nRec

				If nRec >0
					ProcRegua(nRec)
					dbSelectArea("TRB")
					dbGoTop()
					While !Eof()
						IncProc("Apagando cabecalho Onda")
						dbSelectArea("CB7")
						dbSetOrder(1)
						If dbSeek(TRB->CB7_FILIAL+TRB->CB7_ORDSEP)
							RecLock("CB7",.F.)
							dbDelete()
							CB7->(MsUnlock())
						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf
				TRB->(dbCloseArea())
			End Transaction


			MsgInfo("Onda "+cOnda+" cancelada com Sucesso!")
		EndIf
	EndIf
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSAT02B   บAutor  ณPaulo Bindo         บ Data ณ  03/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXIBE OS PEDIDOS FORA DA ONDA                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSAT02B(cSituacao)
	Local oDlgStat
	Local dData 	:= dDataBase
	Local mm		:= 0

	Private aOPsB := {}
	Private oBListBox

	//aOPs {01-OP, 02-STATUS, 03- DT INICIAL, 04-COD PROD OP,05-RECURSO}
	For mm :=1 To Len(aOPs)
		If cSituacao == aOPs[mm][2]
			cStatusOP := aOPs[mm][2]			
			cDescProd:= Posicione("SB1",1,xFilial("SB1")+ aOPs[mm][4],"B1_DESC")
			//01- COR, 02-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO
			cCor := Iif(cStatusOP=="Atendido",LoadBitMap(GetResources(),"BR_VERDE") ,Iif(cStatusOP == "Parcial",LoadBitMap(GetResources(),"BR_AMARELO" ),LoadBitMap(GetResources(),"BR_VERMELHO" )))

			aAdd(aOPsB,{cCor, aOPs[mm][1], aOPs[mm][4], cDescProd, aOPs[mm][3],''})
		EndIf

	Next

	If Len(aOPsB) == 0
		MsgStop("Nใo existem ops "+cSituacao)
		Return
	EndIf	

	ASort(aOPsB,,,{|x,y|x[2]<y[2]})


	//MONTA TELA OPS SEM ONDA
	c2Fields := " "
	n2Campo 	:= 0

	//01- COR, 02-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO
	aBTitCampos := {'',OemToAnsi("OP"),OemToAnsi("Cod.Prod"),OemToAnsi("Descricao"),OemToAnsi("Data Inicio"),''}

	cBLine := "{aOPsB[oBListBox:nAT][1],aOPsB[oBListBox:nAT][2],aOPsB[oBListBox:nAT][3],aOPsB[oBListBox:nAT][4],aOPsB[oBListBox:nAT][5],}"

	bBLine := &( "{ || " + cBLine + " }" )
	nMult := 7
	aBCoord := {nMult*1,nMult*2,nMult*3,nMult*4,nMult*12,nMult*8,''}

	@050,005 TO 500,950  DIALOG oDlgStat TITLE "OPs "
	oBListBox := TWBrowse():New( 10,4,450,170,,aBTitCampos,aBCoord,oDlgStat,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBListBox:SetArray(aOPsB)
	oBListBox:bLDblClick := { ||Processa( {||WSAT02C(aOPsB[oBListBox:nAt,2]) }) }	
	oBListBox:bLine := bBLine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Com Material" OF oDlgStat Color CLR_GREEN PIXEL

	@ 185, 065 BITMAP oBmp2 ResName 	"BR_AMARELO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "Material Parcial" OF oDlgStat Color CLR_RED PIXEL

	@ 185, 125 BITMAP oBmp3 ResName 	"BR_VERMELHO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Material em Falta" OF oDlgStat Color CLR_RED PIXEL


	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgStat:End() PIXEL OF oDlgStat

	ACTIVATE DIALOG oDlgStat CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSAT02B   บAutor  ณPaulo Bindo         บ Data ณ  03/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXIBE OS ITENS DA OP                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSAT02C(cOP)
	Local oDlgOP
	Local dData 	:= dDataBase
	Local mm		:= 0


	Private aOPsC := {}
	Private oCListBox

	//a2ItOPs {01-COR, 02-OP, 03-COD PROD, 04-DESCRICAO, 05-QTDEMP, 06-QTDE OPS, 07-SALDO DISP., 08-SALDO CLASS.,09-SALDO CQ,10-LSEPARA}
	For mm :=1 To Len(a2ItOPs)
		If cOP == a2ItOPs[mm][2]
			cStatusOP :=Iif((a2ItOPs[mm][7]-a2ItOPs[mm][5] )> 0 ,"Atendido",Iif((a2ItOPs[mm][7]-a2ItOPs[mm][5] )< 0 .And. a2ItOPs[mm][7]>0,"Parcial","Falta" ))		

			//01- COR,  02- COD PROD, 03- DESC PROD, 04 -QTDE EMP, 05 - SALDO DISP, 06- RECEBIMENTO, 07- CQ, 08- OPS
			cCor := Iif(cStatusOP=="Atendido",LoadBitMap(GetResources(),"BR_VERDE") ,Iif(cStatusOP == "Parcial",LoadBitMap(GetResources(),"BR_AMARELO" ),LoadBitMap(GetResources(),"BR_VERMELHO" )))

			aAdd(aOPsC,{cCor, a2ItOPs[mm][3], a2ItOPs[mm][4], a2ItOPs[mm][5],a2ItOPs[mm][7],a2ItOPs[mm][8],a2ItOPs[mm][9],a2ItOPs[mm][6],''})
		EndIf

	Next

	If Len(aOPsC) == 0
		MsgStop("Nใo existem produtos nesta OP "+cOP)
		Return
	EndIf	

	ASort(aOPsC,,,{|x,y|x[2]<y[2]})


	//MONTA TELA OPS SEM ONDA
	c2Fields := " "
	n2Campo 	:= 0

	//01- COR,  02- COD PROD, 03- DESC PROD, 04 -QTDE EMP, 05 - SALDO DISP, 06- RECEBIMENTO, 07- CQ, 08- OPS
	aCTitCampos := {'',OemToAnsi("Cod.Prod"),OemToAnsi("Descricao"),OemToAnsi("Empenho"),OemToAnsi("Saldo Disp."),OemToAnsi("Recebimento"),OemToAnsi("CQ"),OemToAnsi("Qtde.OPs"),''}

	cCLine := "{aOPsC[oCListBox:nAT][1],aOPsC[oCListBox:nAT][2],aOPsC[oCListBox:nAT][3],aOPsC[oCListBox:nAT][4],aOPsC[oCListBox:nAT][5],aOPsC[oCListBox:nAT][6],aOPsC[oCListBox:nAT][7],aOPsC[oCListBox:nAT][8],}"

	bCLine := &( "{ || " + cCLine + " }" )
	nMult := 7
	aCCoord := {nMult*1,nMult*4,nMult*12,nMult*8,nMult*8,nMult*8,nMult*8,nMult*8,''}

	@050,005 TO 500,950  DIALOG oDlgOP TITLE "OP :"+cOP
	oCListBox := TWBrowse():New( 10,4,450,170,,aCTitCampos,aCCoord,oDlgOP,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oCListBox:SetArray(aOPsC)	
	oCListBox:bLine := bCLine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgOP Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Com Material" OF oDlgOP Color CLR_GREEN PIXEL

	@ 185, 065 BITMAP oBmp2 ResName 	"BR_AMARELO" OF oDlgOP Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "Material Parcial" OF oDlgOP Color CLR_RED PIXEL

	@ 185, 125 BITMAP oBmp3 ResName 	"BR_VERMELHO" OF oDlgOP Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Material em Falta" OF oDlgOP Color CLR_RED PIXEL


	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOP:End() PIXEL OF oDlgOP

	ACTIVATE DIALOG oDlgOP CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTKRD17CP  บAutor  ณPaulo Bindo         บ Data ณ  03/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXIBE OS PEDIDOS DA ONDA                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSAT02A(cOnda)
	Local oDlgPeds,oFatur,oASep,oSep
	Local dData 	:= dDataBase
	Local lAlter    := .F.
	Local cFDE		:= "N"
	Local nAnda 	:= 0
	Local nAsep  	:= 0
	Local nSep   	:= 0
	Local k			:= 0

	Private aOPsB := {}
	Private oAListBox

	cQuery := " SELECT C2_FILIAL,C2_NUM, C2_ITEM, C2_SEQUEN , C2_DATPRI, C2_PRODUTO, B1_DESC, C2_DATRF, C2__RECURS,C2_QUJE, C2_QUANT,"
	cQuery += " (SELECT TOP 1 CB7__SEQPR FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C2_FILIAL AND CB7_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D_E_L_E_T_ <> '*') CB7__SEQPR,
	cQuery += " (SELECT TOP 1 CB7_ORDSEP FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C2_FILIAL AND CB7_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D_E_L_E_T_ <> '*') CB7_ORDSEP,
	cQuery += " (SELECT TOP 1 CB7__LCALI FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C2_FILIAL AND CB7_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D_E_L_E_T_ <> '*') CB7__LCALI,
	cQuery += " (SELECT COUNT(D4_COD ) FROM "+RetSqlName("SD4")+" WITH(NOLOCK) WHERE D4_FILIAL = C2_FILIAL AND D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D_E_L_E_T_ <> '*') LINHAS"
	cQuery += " FROM "+RetSqlName("SC2")+" C2 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C2_PRODUTO  AND B1_FILIAL = C2_FILIAL  "
	cQuery += " WHERE C2.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' 
	cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN IN (SELECT CB7_OP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = C2_FILIAL AND CB7__PRESE = '"+cOnda+"' AND CB7_OP <> '' AND D_E_L_E_T_ <> '*')"
	cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"' "


	MemoWrite("WSAT02A.SQL",cQuery)

	cQuery += " ORDER BY C2_NUM"


	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	TcSetField("TRB","C2_DATPRI","D")

	Count To nRec1
	aOPsB := {}

	If nRec1 == 0
		//01- COR,02-SEQUECIA ,03-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO, 07-LINHAS, 08- ENDERECO, 09-ORDEM SEPARACAO, 10- RECURSO
		aAdd(aOPsB,{'',0,'','','',cTod(""),0,'',''})
	Else

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()
			IncProc("Calculando OPs ")
			cStatusOP := Posicione("CB7",5,xFilial("CB7")+TRB->C2_NUM+TRB->C2_ITEM+TRB->C2_SEQUEN,"CB7_STATUS")
			//01- COR,02-SEQUECIA ,03-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO, 07-LINHAS
			cCor := Iif((TRB->C2_QUJE >= TRB->C2_QUANT .Or. !Empty(TRB->C2_DATRF)) ,LoadBitMap(GetResources(),"BR_BRANCO" ),Iif(cStatusOP=="9",LoadBitMap(GetResources(),"BR_VERDE") ,Iif(!cStatusOP $ "0|9|",LoadBitMap(GetResources(),"BR_PRETO" ),LoadBitMap(GetResources(),"BR_VERMELHO" ))))
			nAnda  += Iif(!cStatusOP $ "0|9|" ,1,0)
			nAsep  += Iif(cStatusOP == "0",1,0)
			nSep   += Iif(cStatusOP == "9" ,1,0)

			aAdd(aOPsB,{cCor,TRB->CB7__SEQPR,TRB->C2_NUM+TRB->C2_ITEM+TRB->C2_SEQUEN,TRB->C2_PRODUTO,TRB->B1_DESC,TRB->C2_DATPRI, TRB->LINHAS,TRB->CB7__LCALI,TRB->CB7_ORDSEP, TRB->C2__RECURS})

			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())
	ASort(aOPsB,,,{|x,y|x[2]<y[2]})


	//MONTA TELA PEDIDOS EM ABERTO
	c2Fields := " "
	n2Campo 	:= 0

	//01- COR,02-SEQUECIA ,03-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO, 07-LINHAS, 08- ENDERECO, 09-ORDEM SEPARACAO-10 RECURSO
	aATitCampos := {'','',OemToAnsi("OS"),OemToAnsi("Recurso"),OemToAnsi("OP"),OemToAnsi("Cod.Prod"),OemToAnsi("Descricao"),OemToAnsi("Data Inicio"),OemToAnsi("Linhas"),OemToAnsi("Endere็o"),''}

	cALine := "{aOPsB[oAListBox:nAT][1],aOPsB[oAListBox:nAT][2],aOPsB[oAListBox:nAT][9],aOPsB[oAListBox:nAT][10],aOPsB[oAListBox:nAT][3],aOPsB[oAListBox:nAT][4],aOPsB[oAListBox:nAT][5],aOPsB[oAListBox:nAT][6],aOPsB[oAListBox:nAT][7],aOPsB[oAListBox:nAT][8],}"

	bALine := &( "{ || " + cALine + " }" )
	nMult := 7
	aACoord := {nMult*1,nMult*2,nMult*3,nMult*4,nMult*12,nMult*8,''}

	@050,005 TO 500,950  DIALOG oDlgPeds TITLE "OPs "
	oAListBox := TWBrowse():New( 10,4,450,170,,aATitCampos,aACoord,oDlgPeds,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oAListBox:SetArray(aOPsB)
	oAListBox:bLine := bALine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Separada" OF oDlgPeds Color CLR_GREEN PIXEL

	@ 185, 065 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "A Separar" OF oDlgPeds Color CLR_RED PIXEL

	@ 185, 125 BITMAP oBmp3 ResName 	"BR_PRETO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Separando" OF oDlgPeds Color CLR_RED PIXEL

	@ 200, 005 BITMAP oBmp4 ResName 	"BR_BRANCO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 200, 015 SAY "Produzida" OF oDlgPeds Color CLR_RED PIXEL

	//FATURADO
	@ 185, 185 SAY "Separando" OF oDlgPeds  PIXEL
	@ 185, 220 GET oFatur 	Var nAnda 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds

	//A SEPARAR
	@ 185, 270 SAY "A Separar" OF oDlgPeds  PIXEL
	@ 185, 305 GET oASep 	Var nAsep 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds

	//SEPARADO
	@ 185, 355 SAY "Separado" OF oDlgPeds  PIXEL
	@ 185, 385 GET oSep 	Var nSep 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds


	dbSelectArea("SM0")
	//	If U_CHECAFUNC(RetCodUsr(),"WMSAT002") .Or. cFilAnt # "02"
	@ 200,190 BITMAP ResName "PMSSETAUP"   OF oDlgPeds Size 15,15 ON CLICK (MarcaTodos(oAListBox, .T., .T.,3,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.)  NoBorder  Pixel
	@ 200,210 BITMAP ResName "PMSSETADOWN" OF oDlgPeds Size 15,15 ON CLICK (MarcaTodos(oAListBox, .T., .T.,2,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.)  NoBorder  Pixel

	@ 200,230 BUTTON "Ord.OP"		SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,4,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds
	@ 200,270 BUTTON "Ord.Linha"		SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,5,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds
	@ 200,310 BUTTON "Ord.Prod."	    	SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,6,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds

	//	EndIf
	@ 200,350 BUTTON "Vis.OP"	SIZE 40,10 ACTION U_VEROS(aOPsB[oAListBox:nAt,9], cFilAnt) PIXEL OF oDlgPeds
	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgPeds:End() PIXEL OF oDlgPeds

	ACTIVATE DIALOG oDlgPeds CENTERED

	If lAlter
		If MsgYesNo("Voc๊ alterou a ordem dos pedidos, deseja gravar as mudan็as?","ACDAT004")
			For k:=1 To Len(aOPsB)
				dbSelectArea("CB7")
				dbSetOrder(5)
				If dbSeek(xFilial()+aOPsB[k][3])
					RecLock("CB7",.F.)
					CB7__SEQPR := aOPsB[K][2]
					CB7->(MsUnlock())
				EndIf
			Next
		EndIf
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaTodosบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca todos as opcoes do list box - totalizadores           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos(oListBox1, lInverte, lMarca,nItem,nPos)
	Local nX
	Local nUltItem 	:= 0
	Local K			:= 0
	nSomaTot := 0

	If nItem == 3    //SOBE O ITEM
		If nPos ==1
			Return
		EndIf
		//QUANDO FOR O PRIMEIRO ITEM OU NAO ESTIVER SELECIONADO SAI DA ROTINA
		oListBox1:aArray[nPos-1,2] ++           //SOMA ITEM ANTERIOR
		oListBox1:aArray[nPos,2] --				//DIMINIU O ITEM ATUAL
		ASort(aOPsB,,, { |x,y| StrZero(y[2],3) > StrZero(x[2],3) } )
		oListBox1:nAt--
	ElseIf nItem == 2  //DESCE O ITEM
		//QUANDO FOR O ULTIMO ITEM SAI DA ROTINA
		For k:=1 To Len(aOPsB)
			nUltItem++
		Next
		If nPos == nUltItem .Or. nPos == Len(aOPsB)
			Return
		EndIf

		oListBox1:aArray[nPos+1,2] --	//DIMINUI O ITEM ANTERIOR
		oListBox1:aArray[nPos,2] ++		//SOMA O ITEM ATUAL
		ASort(aOPsB,,, { |x,y| StrZero(y[2],3) > StrZero(x[2],3) } )
		oListBox1:nAt ++
		//01- COR,02-SEQUECIA ,03-OP, 04- COD PROD, 05- DESC PROD, 06 -INICIO, 07-LINHAS

	ElseIf nItem == 4  //ORDEM OP
		ASort(aOPsB,,, { |x,y| x[3] < y[3]  } )

		For k:=1 To Len(aOPsB)
			aOPsB[k,2]:= k
		Next
	ElseIf nItem == 5  //LINHA
		If MsgYesNo("Deseja ordenar em ordem crescente?","WMSAT002")
			ASort(aOPsB,,, { |x,y| x[7] < y[7] } )
		Else
			ASort(aOPsB,,, { |x,y| x[7] > y[7] } )
		EndIf
		For k:=1 To Len(aOPsB)
			aOPsB[k,2]:= k
		Next
	ElseIf nItem == 6  //PRODUTO
		ASort(aOPsB,,, { |x,y| y[4] > x[4] } )
		For k:=1 To Len(aOPsB)
			aOPsB[k,2]:= k
		Next
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMACOMP   บAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA DE ACOMPANHAMENTO DA SEPARACAO                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WMACOMP(cOnda)

	Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local oDlgOnda, oLocais,oFinal,oPend,oPFinal,oQOper,oTempo,oMLocal,oOnline
	Private nOnline  := 0
	Private nLocais	:= 0
	Private nFinal	:= 0
	Private nPend		:= 0
	Private nPFinal	:= 0
	Private nQOper	:= 0
	Private nTempo	:= 0
	Private nMLocal	:= 0
	Private aFiltro 	:= {"Todos","Pendente","Finalizado"}
	Private aOrdem 	:= {"Enderecos","Operador","Tempo","% Faltante"}
	Private cFiltro   := "Pendente"
	Private cOrdem	:= "Operador"
	Private cMLocal
	Private cTempo
	Private cHrIni 	:= ""
	Private cHrFim 	:= ""
	Private dDtIni	:= Ctod("")
	Private dDtFim	:= Ctod("")
	Private nDifTempo := 0
	Private oListBox
	Private aAcomp	:={}
	Private aOper	:= {}
	Private aEnder	:= {}
	Private aProd	:={}
	Private cAcompOnda := cOnda
	Private nTamAcolSep := 0

	@ 65,153 To 229,435 Dialog oLocal Title OemToAnsi("Filtro Dados Sepracao")
	@ 19,09 Say OemToAnsi("Dados") Size 99,8 Pixel Of oLocal
	@ 19,49 COMBOBOX cFiltro ITEMS aFiltro  SIZE 35,9 Pixel Of oLocal
	@ 39,09 Say OemToAnsi("Ordena") Size 99,8 Pixel Of oLocal
	@ 39,49 COMBOBOX cOrdem ITEMS aOrdem  SIZE 35,9 Pixel Of oLocal

	@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oLocal)
	Activate Dialog oLocal Centered

	U_AtuSep()

	//QUANDO NAO TEM DADOS SAI DA ROTINA
	If Len(aAcomp) == 0
		Return
	EndIf

	//INICIO TELA
	@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Separacao"

	aTitCampos := {"",OemToAnsi("Cod.Oper."),OemToAnsi("Nome"),OemToAnsi("Ordem Sep."),OemToAnsi("Pausa"),OemToAnsi("Setor"),OemToAnsi("Pecas"),OemToAnsi("Enderecos"),OemToAnsi("%"),;
	OemToAnsi("End.Efetuados"), OemToAnsi("%"),OemToAnsi("Dt.Inicial"),OemToAnsi("Dt.Final"),OemToAnsi("Hr.Inicial"),OemToAnsi("Hr.Final"),OemToAnsi("Tempo"),'End/Min',''}

	cLine := "{aAcomp[oListBox:nAT][1],aAcomp[oListBox:nAt,2],aAcomp[oListBox:nAT][3],aAcomp[oListBox:nAT][4],aAcomp[oListBox:nAT][5],"
	cLine += " aAcomp[oListBox:nAT][6],aAcomp[oListBox:nAT][7],aAcomp[oListBox:nAT][8],aAcomp[oListBox:nAT][9],aAcomp[oListBox:nAT][10],"
	cLine += " aAcomp[oListBox:nAT][11],aAcomp[oListBox:nAT][12],aAcomp[oListBox:nAT][13],aAcomp[oListBox:nAT][14],aAcomp[oListBox:nAT][15],"
	cLine += " aAcomp[oListBox:nAT][16],aAcomp[oListBox:nAT][17],}"
	nMult := 7
	aCoord := {nMult*1,nMult*8,nMult*20,nMult*6,nMult*3,nMult*3,nMult*9,nMult*9,nMult*6,nMult*9, nMult*6,nMult*8,nMult*8,nMult*7,nMult*7,nMult*7,nMult*7,nMult*1}

	bLine := &( "{ || " + cLine + " }" )
	oListBox := TWBrowse():New( 100,4,500,120,,aTitCampos,aCoord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aAcomp)
	oListBox:bLine := bLine


	@ 5,2 TO 90,205 LABEL "Enderecos" OF oDlgOnda  PIXEL

	ASort(aEnder,,,{|x,y|x[2]>y[2]})

	//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
	aE1TitCampos := {OemToAnsi("Setor"),OemToAnsi("Enderecos"),OemToAnsi("End.Feitos"),OemToAnsi("Pecas"),OemToAnsi("Tempo"),OemToAnsi("Min/End"),OemToAnsi("% End."),''}

	cE1Line := "{aEnder[oE1ListBox:nAT][1],Transform(aEnder[oE1ListBox:nAT][2],'@E 99999'),Transform(aEnder[oE1ListBox:nAT][3],'@E 99999'),aEnder[oE1ListBox:nAT][4],U_ConVDecHora(aEnder[oE1ListBox:nAT][5]),"
	cE1Line += " U_ConVDecHora(aEnder[oE1ListBox:nAT][6]),Transform(aEnder[oE1ListBox:nAT][7],'@E 999.99'),}"

	aE1Coord := {2,4,4,9,4,4,4}

	bE1Line := &( "{ || " + cE1Line + " }" )
	oE1ListBox := TWBrowse():New( 17,4,200,70,,aE1TitCampos,aE1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oE1ListBox:SetArray(aEnder)
	oE1ListBox:bLine := bE1Line

	//TOTALIZACAO OPERADORES
	@ 5,215 TO 90,510 LABEL "Produtividade Por Operador" OF oDlgOnda  PIXEL
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS
	ASort(aProd,,,{|x,y|x[2]>y[2]})

	aO2TitCampos := {OemToAnsi("Nome"),OemToAnsi("End.Feitos"),OemToAnsi("Produt."),OemToAnsi("Tempo"),''}

	cO2Line := "{aProd[oO2ListBox:nAT][1],Transform(aProd[oO2ListBox:nAT][2],'@E 99999'),Transform(((aProd[oO2ListBox:nAT][2]/aProd[oO2ListBox:nAT][3])*100),'@E 999.99'),U_ConVDecHora(aProd[oO2ListBox:nAT][4]),}"

	aO1Coord := {10,4,4,,4}

	bO2Line := &( "{ || " + cO2Line + " }" )
	oO2ListBox := TWBrowse():New( 17,220,280,70,,aO2TitCampos,aO1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oO2ListBox:SetArray(aProd)
	oO2ListBox:bLine := bO2Line
	oO2ListBox:bLDblClick := { ||Processa( {||U_ACOSEPPROD(aProd[oO2ListBox:nAT][1]) }) }

	//TOTAL DE ITENS
	@ 227, 005 SAY "Total Locais" OF oDlgOnda Color CLR_RED PIXEL
	@ 227, 060 GET oLocais 	Var nLocais 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//TOTAL ITENS FEITOS

	@ 227, 115 SAY "Locais Finalizados" OF oDlgOnda Color CLR_BROWN PIXEL
	@ 227, 170 GET oFinal 	Var nFinal 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 225 SAY "Locais Pendentes" OF oDlgOnda Color CLR_GREEN PIXEL
	@ 227, 280 GET oPend 	Var nPend 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 335 SAY "% para o Termino" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 390 GET oPFinal 	Var nPFinal	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 227, 445 SAY "Oper.On-Line" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 490 GET oOnline 	Var nOnline	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 240, 005 SAY "Operadores" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 060 GET oQOper 	Var nQOper 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 115 SAY "Tempo Total" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 170 GET oTempo 	Var cTempo 	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 225 SAY "Med.Tempo Local" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 280 GET oMLocal	Var cMLocal	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//@ 200, 335 SAY "Total Pe็as" OF oDlgOnda Color CLR_BLUE PIXEL
	//@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda
	@ 260,210 BUTTON "Atualizar"   	SIZE 40,15 ACTION {U_AtuSep(),oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,270 BUTTON "Pausa"       	SIZE 40,15 ACTION {U_Pausa(aAcomp[oListBox:nAT][4]),aAcomp[oListBox:nAT][5] := "S",oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,330 BUTTON "Exportar"    	SIZE 40,15 ACTION {U_WMAT02EXC()} PIXEL OF oDlgOnda
	@ 260,390 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgOnda:End()} PIXEL OF oDlgOnda

	@ 260, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 015 SAY "Finalizado" OF oDlgOnda Color CLR_GREEN PIXEL

	@ 260, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 090 SAY "Em Andamento" OF oDlgOnda Color CLR_RED PIXEL

	@ 260, 155 BITMAP oBmp3 ResName 	"BR_BRANCO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 165 SAY "Sem Operador" OF oDlgOnda Color CLR_BLACK PIXEL

	//@ 260, 230 BITMAP oBmp4 ResName 	"BR_PRETO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	//@ 260, 240 SAY "Muito Lento" OF oDlgOnda Color CLR_BLACK PIXEL

	ACTIVATE DIALOG oDlgOnda CENTERED

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSEPACOMPบAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA DE ACOMPANHAMENTO DE PRE CHECKOUT                      บฑฑ
ฑฑบ          ณEXP1 - NUMERO ONDA                                          บฑฑ
ฑฑบ          ณEXP2 -P-PRE-CHECKOUT/ C-CHECKOUT                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WMSPCACOMP(cOnda,cOpc)

	Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local oDlgOnda, oLocais,oFinal,oPend,oPFinal,oQOper,oTempo,oMLocal,oOnline,oPedFalta
	Private nLocais	:= 0
	Private nFinal	:= 0
	Private nPend	:= 0
	Private nPFinal	:= 0
	Private nQOper	:= 0
	Private nTempo	:= 0
	Private nMLocal	:= 0
	Private aFiltro 	:= {"Todos","Pendente","Finalizado"}
	Private aOrdem 	:= {"Operador","Tempo","% Faltante","Pedido","Ordem Sep."}
	Private cFiltro   := "Pendente"
	Private cOrdem	:= "Operador"
	Private cMLocal
	Private cTempo
	Private cHrIni 	:= ""
	Private cHrFim 	:= ""
	Private dDtIni	:= Ctod("")
	Private dDtFim	:= Ctod("")
	Private nDifTempo := 0
	Private aOper := {}
	Private oListBox
	Private aAcomp	:={}
	Private cNOpc	:= cOpc
	Private cNOnda	:= cOnda
	Private aProd	:= {}
	Private nOnline := 0
	Private nPedFalta := 0
	Private nTamAcolPre := 0

	@ 65,153 To 229,435 Dialog oLocal Title Iif(cOpc=="P",OemToAnsi("Filtro Dados Pre-Checkout"),OemToAnsi("Filtro Dados Checkout"))
	@ 19,09 Say OemToAnsi("Dados") Size 99,8 Pixel Of oLocal
	@ 19,49 COMBOBOX cFiltro ITEMS aFiltro  SIZE 35,9 Pixel Of oLocal
	@ 39,09 Say OemToAnsi("Ordena") Size 99,8 Pixel Of oLocal
	@ 39,49 COMBOBOX cOrdem ITEMS aOrdem  SIZE 35,9 Pixel Of oLocal

	@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oLocal)
	Activate Dialog oLocal Centered

	U_AtuPre()

	//QUANDO NAO TEM DADOS SAI DA ROTINA
	If Len(aAcomp) == 0
		Return
	EndIf


	aTitCampos := {"",OemToAnsi("Cod.Oper."),OemToAnsi("Nome"),OemToAnsi("Pedido"),OemToAnsi("Ordem Sep."),OemToAnsi("Pausa"),OemToAnsi("Pecas"),OemToAnsi("Linhas"),OemToAnsi("%"),;
	OemToAnsi("Linhas.Efetuadas"), OemToAnsi("%"),OemToAnsi("Dt.Inicial"),OemToAnsi("Dt.Final"),OemToAnsi("Hr.Inicial"),OemToAnsi("Hr.Final"),OemToAnsi("Tempo"),'Linha/Min',''}

	cLine := "{aAcomp[oListBox:nAT][1],aAcomp[oListBox:nAt,2],aAcomp[oListBox:nAT][3],aAcomp[oListBox:nAT][18],aAcomp[oListBox:nAT][4],aAcomp[oListBox:nAT][5],"
	cLine += " aAcomp[oListBox:nAT][7],aAcomp[oListBox:nAT][8],aAcomp[oListBox:nAT][9],aAcomp[oListBox:nAT][10],"
	cLine += " aAcomp[oListBox:nAT][11],aAcomp[oListBox:nAT][12],aAcomp[oListBox:nAT][13],aAcomp[oListBox:nAT][14],aAcomp[oListBox:nAT][15],"
	cLine += " aAcomp[oListBox:nAT][16],aAcomp[oListBox:nAT][17],}"

	nMult := 7
	aCoord := {nMult*1,nMult*8,nMult*20,nMult*6,nMult*3,nMult*9,nMult*9,nMult*6,nMult*9, nMult*6,nMult*8,nMult*8,nMult*7,nMult*7,nMult*7,nMult*7,nMult*1}


	bLine := &( "{ || " + cLine + " }" )

	If cOpc == "P"
		@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Pre-Checkout"
	Else
		@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Checkout"
	EndIf
	oListBox := TWBrowse():New( 100,4,500,120,,aTitCampos,aCoord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aAcomp)
	oListBox:bLine := bLine

	//TOTALIZACAO OPERADORES
	@ 5,2 TO 90,205 LABEL "Produtividade Por Operador" OF oDlgOnda  PIXEL
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS
	ASort(aProd,,,{|x,y|x[2]>y[2]})

	aO2TitCampos := {OemToAnsi("Nome"),OemToAnsi("End.Feitos"),OemToAnsi("Produt."),OemToAnsi("Tempo"),OemToAnsi("Min./Linha"),''}

	cO2Line := "{aProd[oO2ListBox:nAT][1],Transform(aProd[oO2ListBox:nAT][2],'@E 99999'),Transform(((aProd[oO2ListBox:nAT][2]/aProd[oO2ListBox:nAT][3])*100),'@E 999.99'),U_ConVDecHora(aProd[oO2ListBox:nAT][4]),U_ConVDecHora(aProd[oO2ListBox:nAT][5]),}"

	aO1Coord := {10,4,4,,4}

	bO2Line := &( "{ || " + cO2Line + " }" )
	oO2ListBox := TWBrowse():New( 17,4,200,70,,aO2TitCampos,aO1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oO2ListBox:SetArray(aProd)
	oO2ListBox:bLine := bO2Line
	//oO2ListBox:bLDblClick := { ||Processa( {||U_ACOSEPPROD(aProd[oO2ListBox:nAT][1]) }) }

	//TOTAL DE ITENS
	@ 227, 005 SAY "Total Linhas" OF oDlgOnda Color CLR_RED PIXEL
	@ 227, 060 GET oLocais 	Var nLocais 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//TOTAL ITENS FEITOS

	@ 227, 115 SAY "Linhas Finalizadas" OF oDlgOnda Color CLR_BROWN PIXEL
	@ 227, 170 GET oFinal 	Var nFinal 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 225 SAY "Linhas Pendentes" OF oDlgOnda Color CLR_GREEN PIXEL
	@ 227, 280 GET oPend 	Var nPend 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 335 SAY "% para o Termino" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 390 GET oPFinal 	Var nPFinal	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 227, 445 SAY "Oper.On-Line" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 490 GET oOnline 	Var nOnline	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda



	@ 240, 005 SAY "Operadores" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 060 GET oQOper 	Var nQOper 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 115 SAY "Tempo Total" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 170 GET oTempo 	Var cTempo 	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 225 SAY "Med.Tempo Linha" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 280 GET oMLocal	Var cMLocal	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 335 SAY "Pedidos Falta" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 390 GET oPedFalta	Var nPedFalta	Picture "@E 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//@ 200, 335 SAY "Total Pe็as" OF oDlgOnda Color CLR_BLUE PIXEL
	//@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	//BOTOES
	@ 260,270 BUTTON "Atualizar"   	SIZE 40,15 ACTION {U_AtuPre(),oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,330 BUTTON "Pausa"       	SIZE 40,15 ACTION {U_Pausa(aAcomp[oListBox:nAT][4]),aAcomp[oListBox:nAT][5] := "S",oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,390 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgOnda:End()} PIXEL OF oDlgOnda

	//@ 220,310 SAY "Busca Pedido:" SIZE 65,9 PIXEL OF oDlgOnda
	//@ 220,360 MSGET oSeek VAR cPesqPV SIZE 40,7 Valid (Iif(!Empty(cPesqPV),(Busca(cPesqPV,oListBox),cPesqPV := Space(06),oListBox:Refresh(),oSeek:SetFocus()),)) PIXEL OF oDlgOnda

	@ 260, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 015 SAY "Finalizado" OF oDlgOnda Color CLR_GREEN PIXEL

	@ 260, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 090 SAY "Em Andamento" OF oDlgOnda Color CLR_RED PIXEL

	@ 260, 155 BITMAP oBmp3 ResName 	"BR_BRANCO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 165 SAY "Sem Operador" OF oDlgOnda Color CLR_BLACK PIXEL

	//@ 260, 230 BITMAP oBmp4 ResName 	"BR_PRETO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	//@ 260, 240 SAY "Muito Lento" OF oDlgOnda Color CLR_BLACK PIXEL

	ACTIVATE DIALOG oDlgOnda CENTERED


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  02/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConVDecHora(nCent)
	nHora	:= Int(nCent)
	nMinuto := (nCent-nHora)*(.6)*100
	nSec    := nMinuto*60
	cString := StrZero(nHora,Iif(nHora>99,3,2))+StrZero(nMinuto,2)+StrZero(Int(Mod(nSec,60)),2,0)

	cHor := Transform(cString,Iif(nHora>99,'@R 999:99:99','@R 99:99:99'))
Return(cHor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMAT02EXC บAutor  ณMicrosiga           บ Data ณ  02/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXPORTA DADOS SEPARACAO PARA EXCEL                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WMAT02EXC()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local nTamLin, cLin, cCpo
	local cDirDocs  := MsDocPath()
	Local cError 	:= ""
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "SEPARACAO"+cAcompOnda+".CSV"
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX
	Local nTotEnd := 0
	Local Kx		:= 0	
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"


	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("Nใo foi possํvel abrir o arquivo CSV pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o arquivo texto                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	//CABECALOS ESTATISTICAS ENDERECOS
	cLin := "DISTRIBUICAO ENDERECOS"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin    :=  OemToAnsi("Setor")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("% End.")
	cLin += cEOL //ULTIMO ITEM

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aEnder))

	For Kx:=1 To Len(aEnder)
		IncProc("Aguarde......Montando Planilha enderecos!")
		nTotEnd += aEnder[Kx][2]
		cLin    := ''
		cLin    += aEnder[Kx][1]+';'+Transform(aEnder[Kx][2],'@E 99999')+';'+Transform(aEnder[Kx][3],'@E 99999')+';'+Transform(aEnder[Kx][4],'@E 99999')+';'+U_ConVDecHora(aEnder[Kx][5])+';'+U_ConVDecHora(aEnder[Kx][6])+';'+Transform(aEnder[Kx][7],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//PULA LINHA
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR X SETOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR X SETOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Setor")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("Produt.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aOper))
	//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
	ASort(aOper,,,{|x,y|x[7]+StrZero(x[9],4)>y[7]+StrZero(y[9],4)})

	For Kx:=1 To Len(aOper)
		IncProc("Aguarde......Montando Planilha Operadores!")
		cLin    := ''
		cLin    += aOper[Kx][2]+';'+Transform(aOper[Kx][3],'@E 99999')+';'+Transform(aOper[Kx][6],'@E 99999')+';'+Transform(aOper[Kx][5],'@E 99999')+';'+U_ConVDecHora(aOper[Kx][4])+';'
		cLin    += aOper[Kx][7]+';'+U_ConVDecHora(aOper[Kx][8])+';'+Transform(aOper[Kx][9],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	cLin := ""
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("Produt.")+';'+OemToAnsi("Tempo")+";"+OemToAnsi("Min/End.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aProd))
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
	ASort(aProd,,,{|x,y|x[5]>y[5]})

	For Kx:=1 To Len(aProd)
		IncProc("Aguarde......Montando Planilha Produtividade!")
		cLin    := ''
		cLin    += aProd[Kx][1]+';'+Transform(aProd[Kx][2],'@E 99999')+';'+Transform((aProd[Kx][2]/aProd[Kx][3])*100,'@E 999.99')+';'+U_ConVDecHora(aProd[Kx][4])+';'+U_ConVDecHora(aProd[Kx][4]/aProd[Kx][2])

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next


	fClose(nHdl)

	CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cPath+cArquivo,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOSEPPRODบAutor  ณMicrosiga           บ Data ณ  02/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA COM A PRODUTIVIDADE POR OPERADOR NA SEPARACAO          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOSEPPROD(cNomOper)
	Local oDlgOper
	Local a2Oper := {}
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Local Kx		:= 0


	For Kx:=1 To Len(aOper)
		If aOper[Kx][2] == cNomOper
			aAdd(a2Oper,{aOper[Kx][1],aOper[Kx][2],aOper[Kx][3],aOper[Kx][4],aOper[Kx][5],aOper[Kx][6],aOper[Kx][7],aOper[Kx][8],aOper[Kx][9]})
		EndIf
	Next

	//TOTALIZACAO OPERADORES
	ASort(a2Oper,,,{|x,y|x[7]>y[7]})
	@050,005 TO 300,550  DIALOG oDlgOper TITLE "Dados Operador x Separacao "

	//a2Oper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO

	aOP2TitCampos := {OemToAnsi("Codigo"),OemToAnsi("Nome"),OemToAnsi("Enderecos"),OemToAnsi("End.Feitos"),OemToAnsi("Pecas"),OemToAnsi("Tempo"),OemToAnsi("Setor"),OemToAnsi("Min/End"),OemToAnsi("Produt."),''}

	cOP2Line := "{a2Oper[oOP2ListBox:nAT][1],a2Oper[oOP2ListBox:nAT][2],Transform(a2Oper[oOP2ListBox:nAT][3],'@E 99999'),Transform(a2Oper[oOP2ListBox:nAT][6],'@E 99999'),a2Oper[oOP2ListBox:nAT][5],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][4]),"
	cOP2Line += " a2Oper[oOP2ListBox:nAT][7],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][8]),Transform(a2Oper[oOP2ListBox:nAT][9],'@E 999.99'),}"

	aOP2Coord := {3,10,4,4,9,4,2,4,4,1}

	bOP2Line := &( "{ || " + cOP2Line + " }" )
	oOP2ListBox := TWBrowse():New( 10,4,270,90,,aOP2TitCampos,aOP2Coord,oDlgOper,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oOP2ListBox:SetArray(a2Oper)
	oOP2ListBox:bLine := bOP2Line

	@ 100,200 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOper:End() PIXEL OF oDlgOper

	ACTIVATE DIALOG oDlgOper CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  02/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSAT02SB(cOnda)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local nTamLin, cLin, cCpo
	local cDirDocs  := MsDocPath()
	Local cError 	:= ""
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "WSAT02SB.CSV"
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local n			:= 0
	Local aTam		:= {}
	Local nX


	Private cString := "TRB"
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"

	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("Nใo foi possํvel abrir o arquivo WSAT02SB.CSV pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o arquivo texto                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	cQuery := " SELECT ZK_NOME, ZK_PROD, ZK_DESC, ZK_LCALIZ FROM "+RetSqlName("SZK")
	cQuery += " WHERE ZK__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*' "
	cQuery += " AND ZK_ETAPA = 'SEPARACAO' "
	cQuery += " AND ZK_FILIAL = '"+cFilAnt+"'"

	MEMOWRITE("WSAT02SB.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nCount

	If nCount == 0
		MsgStop("Nใo foram encontrados dados!","Aten็ใo - WSAT02SB")
		TRB->(dbCloseArea())
		Return
	EndIf

	For n := 1 to FCount()
		aTam := TamSX3(FieldName(n))
		If !Empty(aTam) .and. aTam[3] $ "N/D"
			TCSETFIELD(cString,FieldName(n),aTam[3],aTam[1],aTam[2])
		EndIf
	Next

	dbSelectArea("TRB")
	dbGoTop()
	ProcRegua(nCount)
	If !EOF()
		cLin    := ''
		For n := 1 to FCount()
			cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
			cLin += ';'
		Next
		cLin += cEOL //ULTIMO ITEM
	EndIf

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(nCount)
	While !EOF()
		IncProc("Aguarde......Montando Planilha!")
		cLin    := ''

		For n := 1 to FCount()

			cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
			cLin += ';'
		Next

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRB->(dbCloseArea())
			fClose(nHdl)
			Return
		Endif
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	fClose(nHdl)

	CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cPath+cArquivo,"","", 1 )
		TRB->(dbCloseArea())
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
	//ณ cao anterior.                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TRB->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  02/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Pausa(cPOrdSep)

	cQuery := " UPDATE "+RetSqlName("CB7")+" SET CB7_STATPA = '1' WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7_ORDSEP = '"+cPOrdSep+"' AND D_E_L_E_T_ <> '*'"

	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualiza็ใo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf

	MsgInfo("Em Pausa!","WMSAT002")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuPre    บAutor  ณMicrosiga           บ Data ณ  03/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o pre checkout                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuPre()
	Local nMinEnd 	:= 0
	Local aOper		:= {} 
	Local Kx		:= 0

	nLocais	:= 0
	nFinal	:= 0
	nPend	:= 0
	nPFinal	:= 0
	nQOper	:= 0
	nTempo	:= 0
	nMLocal	:= 0
	nOnline := 0
	nDifTempo := 0
	aOper := {}
	aAcomp	:={}
	aProd	:= {}
	nPedFalta := 0
	cTempo	:= ""
	cMLocal	:= ""


	cQuery := " SELECT "
	If cNOpc == "P"
		cQuery += " CB7__CODOP AS CB7_CODOPE, "
	Else
		cQuery += " CB7_CODOPE , "
	EndIf
	cQuery += " CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_PEDIDO, CB7_NOTA, CB7__CHECK ,CB7_STATUS,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LINHAS,"
	If cNOpc == "P"
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8__SALDO = 0) LINHAS_FEITAS,"
		cQuery += " CB7__DTINI  ,"
		cQuery += " CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7__HRFIM      ,1,2)+':'+SUBSTRING(CB7__HRFIM     ,3,2) HR_FIM"
	Else
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LINHAS_FEITAS,"
		cQuery += " CB7_DTINIS CB7__DTINI  ,"
		cQuery += " CB7_DTFIMS CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	EndIf
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL "
	If cNOpc == "P"
		cQuery += " AND CB1_CODOPE = CB7__CODOP "
	Else
		cQuery += " AND CB1_CODOPE = CB7_CODOPE "
	EndIf
	cQuery += " WHERE CB7__PRESE = '"+cNOnda+"' "
	cQuery += " and CB7_PEDIDO <> ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LINHAS DESC"

	MemoWrite("WMSAT00216.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7__DTINI','D')
	TcSetField('TRBAC','CB7__DTFIM','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LINHAS

		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE })
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LINHAS,0,TRBAC->PECAS, TRBAC->LINHAS_FEITAS, '', 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LINHAS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LINHAS_FEITAS
		EndIf

		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7__DTINI
	dDtFim := TRBAC->CB7__DTFIM

	While !Eof()
		IncProc("Gerando dados")

		nLcPorc 	:= (TRBAC->LINHAS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LINHAS_FEITAS/TRBAC->LINHAS)*100
		cCor		:= Iif(TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0 .Or. (TRBAC->CB7__CHECK == "2"  .And. cNOpc == "P"),"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0
			nFinal+= TRBAC->LINHAS_FEITAS
		Else
			nPend+= TRBAC->LINHAS-TRBAC->LINHAS_FEITAS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametrosณ ExpD1 - Data Inicial
		ณ ExpN1 - Hor rio Inicial
		ณ ExpD2 - Data Final
		ณ ExpN2 - Hor rio Final
		*/

		If !(Len(AllTrim(TRBAC->HR_INI)) < 5 .Or. Len(AllTrim(TRBAC->HR_FIM)) < 5) .And. !Empty(TRBAC->CB7__DTINI) .And. !Empty(TRBAC->CB7__DTFIM)
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7__DTINI
				dDtIni := TRBAC->CB7__DTINI
			EndIf
			If dDtFim < TRBAC->CB7__DTFIM
				dDtFim := TRBAC->CB7__DTFIM
			EndIf

			nDifTempo	:= A680Tempo( TRBAC->CB7__DTINI,TRBAC->HR_INI,TRBAC->CB7__DTFIM,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"12:00",TRBAC->CB7__DTFIM,"13:00" )
				nDifTempo -= nTemp24
			EndIf
			//NAO CONTA PERIODO NOTURNO
			If TRBAC->CB7__DTINI #TRBAC->CB7__DTFIM
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"22:00",TRBAC->CB7__DTFIM,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			nTempo+=nDifTempo

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo := U_ConVDecHora(nDifTempo)

		Else
			nDifTempo := 0
			cDifTempo := "00:00"
		EndIf

		nEndMin := nDifTempo/TRBAC->LINHAS
		cEndMin := U_ConVDecHora(nEndMin)


		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS > 0 .And. Empty(TRBAC->CB7_NOTA) .And. Iif( cNOpc == "P",TRBAC->CB7__CHECK <> "2",TRBAC->CB7_STATUS <> "9")) .Or. (cFiltro == "Finalizado" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			If cFiltro == "Pendente"  .Or. (cFiltro == "Todos" .And. TRBAC->CB7__CHECK <> "2" .And. Empty(TRBAC->CB7_NOTA))
				nPedFalta ++
			EndIf

			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"999999",TRBAC->CB7_CODOPE),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"FATURADO S/ PRE-CHECKOUT",Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME)),;
			TRBAC->CB7_ORDSEP,;
			Iif(TRBAC->CB7_STATPA == "1","S","N"),;
			'',;
			TRBAC->PECAS,;
			TRBAC->LINHAS,;
			Transform(nLcPorc,"@E 999.99"),;
			TRBAC->LINHAS_FEITAS,;
			Transform(nLcEfPorc,"@E 999.99"),;
			DTOC(TRBAC->CB7__DTINI),;
			DTOC(TRBAC->CB7__DTFIM),;
			TRBAC->HR_INI,;
			TRBAC->HR_FIM,;
			cDifTempo,;
			cEndMin,;
			TRBAC->CB7_PEDIDO,;
			''})
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End

	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LINHAS,04-TEMPO, 05-PECAS, 06-LINHAS FEITAS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE LINHA
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd
		aOper[Kx][9]+= (aOper[Kx][3]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //SOMA MIN/LINHA
		EndIf
	Next



	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= (nTempo/nFinal)
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo  := U_ConVDecHora(nTempo)
	cMLocal := U_ConVDecHora(nMLocal)

	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())

	If nTamAcolPre == 0
		nTamAcolPre := Len(aAcomp)
	ElseIf nTamAcolPre <> Len(aAcomp)
		While nTamAcolPre <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			aAdd(aAcomp,{'','','Z','ZZZZZZ','','',0,0,0,0,0,CTOD(''),CTOD(''),":",":",0,0,''})
		End
	EndIf



	If Len(aAcomp) == 0
		If cNOpc == "P"
			MsgInfo("Nใo existem mais Pre-checkouts pendentes!")
		Else
			MsgInfo("Nใo existem mais Checkouts pendentes!")
		EndIf
		Return
	EndIf

	If cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	ElseIf cOrdem == "Pedido"
		ASort(aAcomp,,,{|x,y|x[18]<y[18]})
	ElseIf cOrdem == "Ordem Sep."
		ASort(aAcomp,,,{|x,y|x[4]<y[4]})
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSep    บAutor  ณMicrosiga           บ Data ณ  03/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณATUALIZA DADOS SEPARACAO                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuSep()
	Local Kx	:= 0

	nOnline := 0
	nLocais := 0
	nFinal 	:= 0
	nPend 	:= 0
	nPFinal	:= 0
	nOnline	:= 0
	nQOper 	:= 0
	cTempo 	:= ""
	cMLocal	:= ""
	aOper	:= {}
	aEnder	:= {}
	aProd	:={}


	cQuery := " SELECT CB7_CODOPE , CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_STATUS ,"
	cQuery += " (SELECT TOP 1 CASE WHEN ((SUBSTRING(CB8_LCALIZ,9,1) > '2' AND LEFT(CB8_LCALIZ,2)= 'PP')OR LEFT(CB8_LCALIZ,2)= 'PI') THEN
	cQuery += " 'EM'"
	cQuery += " ELSE"
	cQuery += " LEFT(CB8_LCALIZ,2) "
	cQuery += " END  FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' ORDER BY CB8_LCALIZ DESC) SETOR,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LOCAIS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LOCAIS_FEITOS,"
	cQuery += " CB7_DTINIS  ,"
	cQuery += " CB7_DTFIMS  ,"
	cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
	cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL AND CB1_CODOPE = CB7_CODOPE "
	cQuery += " WHERE CB7__PRESE = '"+cAcompOnda+"' "
	cQuery += " and CB7_PEDIDO = ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LOCAIS DESC"

	MemoWrite("WMSAT00215.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7_DTINIS','D')
	TcSetField('TRBAC','CB7_DTFIMS','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LOCAIS
		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LOCAIS,0,TRBAC->PECAS, TRBAC->LOCAIS_FEITOS, TRBAC->SETOR, 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LOCAIS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LOCAIS_FEITOS
		EndIf

		//ARMAZENA ESTATISTICAS DA ONDA
		nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
		If nAscan == 0
			//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
			aAdd(aEnder,{TRBAC->SETOR,TRBAC->LOCAIS,TRBAC->LOCAIS_FEITOS,TRBAC->PECAS,0,0,0})
		Else
			aEnder[nAscan][2] += TRBAC->LOCAIS
			aEnder[nAscan][3] += TRBAC->LOCAIS_FEITOS
			aEnder[nAscan][4] += TRBAC->PECAS
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7_DTINIS
	dDtFim := TRBAC->CB7_DTFIMS

	While !Eof()
		IncProc("Gerando dados")
		nLcPorc 	:= (TRBAC->LOCAIS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LOCAIS_FEITOS/TRBAC->LOCAIS)*100
		cCor		:= Iif(TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0,"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0
			nFinal+= TRBAC->LOCAIS_FEITOS
		Else
			nPend+= TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametrosณ ExpD1 - Data Inicial
		ณ ExpN1 - Hor rio Inicial
		ณ ExpD2 - Data Final
		ณ ExpN2 - Hor rio Final
		*/
		If TRBAC->HR_INI # "  :  "
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7_DTINIS
				dDtIni := TRBAC->CB7_DTINIS
			EndIf
			If dDtFim < TRBAC->CB7_DTFIMS
				dDtFim := TRBAC->CB7_DTFIMS
			EndIf
			nDifTempo	:= A680Tempo( TRBAC->CB7_DTINIS,TRBAC->HR_INI,TRBAC->CB7_DTFIMS,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"12:00",TRBAC->CB7_DTFIMS,"13:00" )
				nDifTempo -= nTemp24
			EndIf

			//NAO CONTA PERIODO DA NOITE
			If TRBAC->CB7_DTINIS #TRBAC->CB7_DTFIMS
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"22:00",TRBAC->CB7_DTFIMS,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			nTempo+=nDifTempo

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			//ARMAZENA ESTATISTICAS DA ONDA
			nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
			If nAscan > 0
				//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO
				aEnder[nAscan][5] += nDifTempo
			EndIf

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo:= U_ConVDecHora(nDifTempo)
		Else
			cDifTempo	:= '00:00'
		EndIf
		nEndMin := nDifTempo/TRBAC->LOCAIS
		cEndMin:= U_ConVDecHora(nEndMin)

		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS > 0 .And. TRBAC->CB7_STATUS <> '9' ) .Or. (cFiltro == "Finalizado" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0 .And.  TRBAC->CB7_STATUS = '9')
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),TRBAC->CB7_CODOPE,Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME),TRBAC->CB7_ORDSEP, Iif(TRBAC->CB7_STATPA == "1","S","N"), TRBAC->SETOR, TRBAC->PECAS, TRBAC->LOCAIS, Transform(nLcPorc,"@E 999.99"),TRBAC->LOCAIS_FEITOS,Transform(nLcEfPorc,"@E 999.99"),DTOC(TRBAC->CB7_DTINIS), DTOC(TRBAC->CB7_DTFIMS), TRBAC->HR_INI, TRBAC->HR_FIM,cDifTempo,cEndMin,''})
		EndIf


		dbSelectArea("TRBAC")
		dbSkip()
	End
	//nTempo	:= A680Tempo( dDtIni,cHrIni,dDtFim,cHrFim )

	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= nTempo/nFinal
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo:= U_ConVDecHora(nTempo)
	cMLocal:= U_ConVDecHora(nMLocal)


	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd

		nAscan := Ascan(aEnder, {|e| e[1] == aOper[Kx][7]})
		aOper[Kx][9]+= (aOper[Kx][3]/aEnder[nAscan][2])*100
	Next

	For kx:=1 To Len(aEnder)
		//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
		aEnder[Kx][6] += aEnder[Kx][5]/aEnder[Kx][2]
		aEnder[Kx][7] += (aEnder[Kx][2]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //MINUTOS ENDERECOS
		EndIf
	Next



	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())


	If nTamAcolSep == 0
		nTamAcolSep := Len(aAcomp)
	ElseIf nTamAcolSep <> Len(aAcomp)
		While nTamAcolSep <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{'','','Z','','','',0,0,0,0,0,CTOD(''),CTOD(''),"","",0,0})
		End
	EndIf

	If Len(aAcomp) == 0
		MsgInfo("Nใo existem mais enderecos pendentes!")
		Return
	EndIf


	If cOrdem == "Enderecos"
		ASort(aAcomp,,,{|x,y|x[8]+x[14]>y[8]+y[14]})
	ElseIf cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LibOnda(cLOnda,cOper,cTrava)

	If MsgYesNo("Esta rotina libera/bloqueia a onda para separa็ใo, deseja prosseguir?","ACDAT004")
		cQuery := " UPDATE "+RetSqlName("CB7")
		cQuery += " SET CB7__TRAVA = '"+Iif(cTrava == "N","S","N")+"'"
		cQuery += " WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7__PRESE = '"+cLOnda+"'
		cQuery += " AND CB7_OP <> ''"
		cQuery += " AND D_E_L_E_T_ <> '*'"

		If TcSqlExec(cQuery) <0
			UserException( "Erro na atualiza็ใo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
		EndIf

		aOnda[o1ListBox:nAt,12]:= Iif(cTrava == "N","S","N")
		aOnda[o1ListBox:nAt,1] := Iif(cTrava == "N",LoadBitMap(GetResources(),"BR_AZUL"),LoadBitMap(GetResources(),"BR_VERDE"))
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AlertaOnda()
	Local oDlgOper
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Private aAlerta := {}
	Private cAOnda
	Private cACrono		:= "00:00"							// Cronometro da ligacao atual
	Private oACrono
	Private cATimeOut		:= "00:00"                        	// Time out do atendimento (Posto de venda)
	Private nATimeSeg		:= 0                      			// Segundos do cronograma
	Private nATimeMin		:= 0                      			// Minutos do cronograma
	Private nTamAcolAle		:= 0
	U_ALWSAT02()

	If Len(aAlerta) == 0
		aAdd(aAlerta,{'','', '  /  /  ','','',0,''})
	EndIf

	@050,005 TO 450,550  DIALOG oDlgOper TITLE "Alerta Onda"
	//01-OPERADOR, 02-NOME, 03-DATA INICIAL, 04- HORA INICIAL, 05-ALERTA, 06 -TEMPO DECORRIDO, 07- OPERACAO

	aOP2TitCampos := {'',OemToAnsi("Codigo"),OemToAnsi("Nome"),OemToAnsi("Data Inicio"),OemToAnsi("Hora Inicio"),OemToAnsi("Tempo"),OemToAnsi("Operacใo"),''}

	cOP2Line := "{aAlerta[oOP2ListBox:nAT][5],aAlerta[oOP2ListBox:nAT][1],aAlerta[oOP2ListBox:nAT][2],aAlerta[oOP2ListBox:nAT][3],aAlerta[oOP2ListBox:nAT][4],U_ConVDecHora(aAlerta[oOP2ListBox:nAT][6]),aAlerta[oOP2ListBox:nAT][7],''}"

	aOP2Coord := {2,6,15,6,6,6,,6,1}

	bOP2Line := &( "{ || " + cOP2Line + " }" )
	oOP2ListBox := TWBrowse():New( 10,4,270,160,,aOP2TitCampos,aOP2Coord,oDlgOper,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oOP2ListBox:SetArray(aAlerta)
	oOP2ListBox:bLine := bOP2Line

	@ 180,150 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOper:End() PIXEL OF oDlgOper
	@ 180,210 SAY oACrono VAR cACrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgOper

	oATimer := TTimer():New( 10 * 1000, {||ALERTAAtuCro(1)  }, oDlgOper )
	oATimer:lActive   := .T. // para ativar

	ACTIVATE DIALOG oDlgOper CENTERED


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ALWSAT02()
	aAlerta := {}
	//ZERA O CRONOMETRO
	nATimeMin := 0
	nATimeSeg := 0
	cATimeAtu := "00:00"

	//Cursorwait()

	cQuery := " SELECT CB1_CODOPE , CB1_NOME,"
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9'  AND CB7_DTFIMS = '' AND CB7_PEDIDO = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  SEPARACAO,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7__CODOP = CB1_CODOPE  AND CB7__CHECK <> '2' AND CB7_PEDIDO <> '' AND CB7__DTFIM = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  PRECHECKOUT,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9' AND CB7_PEDIDO <> '' AND CB7_DTFIMS = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  CHECKOUT
	cQuery += " FROM "+RetSqlName("CB1")+"  CB1"
	cQuery += " WHERE"
	cQuery += " CB1_FILIAL = '"+cFilAnt+"' AND CB1.D_E_L_E_T_ <> '*' AND CB1_STATUS = '1'"

	MemoWrite("WMST0ALERTA.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAL", .F., .T.)

	Count To nRec

	If nRec == 0
		MsgAlert("Nใo existem operadores trabalhando no momento!","WMSAT002")
		TRBAL->(dbCloseArea())
	EndIf

	dbSelectArea("TRBAL")
	dbGoTop()

	While !Eof()
		If Empty(TRBAL->SEPARACAO) .And. Empty(TRBAL->PRECHECKOUT) .And. Empty(TRBAL->CHECKOUT)
			dbSkip()
			Loop
		EndIf
		//VERIFICA NA SEPARACAO
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->SEPARACAO)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			//01-OPERADOR, 02-NOME, 03-DATA INICIAL, 04- HORA INICIAL, 05-ALERTA, 06 -TEMPO DECORRIDO, 07- OPERACAO
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE) ,"SEPARACAO"})
		EndIf

		//VERIFICA PRE-CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->PRECHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2)
			If !Empty(CB7__DTINI)
				nDifTempo	:= A680Tempo( CB7__DTINI,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)) )
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO") 
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7__DTINI),cHrini,cCor,(nDifTempo/CB7_NUMITE), "PRE-CHECKOUT"})
		EndIf

		//VERIFICA CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->CHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE),"CHECKOUT"})
		EndIf

		dbSelectArea("TRBAL")
		dbSkip()
	End

	If nTamAcolAle == 0
		nTamAcolAle := Len(aAlerta)
	ElseIf nTamAcolAle <> Len(aAlerta)
		While nTamAcolAle <> Len(aAlerta)
			aAdd(aAlerta,{'','Z',CTOD(''),'',"",0,''})
		End
	EndIf

	ASort(aAlerta,,,{|x,y|x[6]>y[6]})
	TRBAL->(dbCloseArea())
	//CursorArrow()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSAT002  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ALERTAAtuCro(nTipo)
	Local cATimeAtu := ""

	cATimeOut := "03:00"

	nATimeSeg += 10

	If nATimeSeg > 59
		nATimeMin ++
		nATimeSeg := 0
		If nATimeMin > 60
			nATimeMin := 0
		Endif
	Endif

	cATimeAtu := STRZERO(nATimeMin,2,0)+":"+STRZERO(nATimeSeg,2,0)

	If cATimeAtu >= cATimeOut
		oACrono:nClrText := CLR_RED
		oACrono:Refresh()

		U_ALWSAT02()

	Endif

	cACrono := cATimeAtu
	oACrono:Refresh()
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDAT4STATUSบAutor  ณMicrosiga        บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSTATUS DA IMPORTACAO APONTAMENTO                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ACDAT4APONT()

	Local aArea := GetArea()
	private _aArqSel := {"CBH","SC2"}
	private cArq    :=""
	private cCampos :="CBH_QTD,CBH_OP,CBH_RECUR,CBH_DTINI,CBH_DTFIM,CBH_HRFIM,CBH_OPERAD,C2_QUANT,CBH_HRINI,"
	private aFields :={}

	cria_TCBH()
	processa({|| monta_TCBH()},"Selecionando registros...")

	aTela :={}
	aAdd(aTela,{"CBH_OP"   		,"OP"								})
	aAdd(aTela,{"C2_QUANT" 		,"Qtd.OP"		,"@E 999,999.99"	})
	aAdd(aTela,{"CBH_QTD"		,"Qtd.Produzida","@E 999,999.99"	})
	aAdd(aTela,{"CBH_RECUR"  	,"Recurso"							})
	aAdd(aTela,{"CBH_DTINI"		,"Data Inicial" 					})
	aAdd(aTela,{"CBH_HRINI"   	,"Hora Inicial"						})
	aAdd(aTela,{"CBH_DTFIM" 	,"Data Final"						})
	aAdd(aTela,{"CBH_HRFIM" 	,"Hora Final"		                })
	aAdd(aTela,{"CBH_OPERAD" 	,"Qtde.Operadores"	,"@E 99"        })

	cStatus := Iif(GetMV("MV__ACDR4")=="N","Ociosa","Em Execucao")
	cTempo	:= GetMV("MV__ACDR42")

	@ 310,0 to 520,799 dialog oDlg2 title "Ops em Processo"
	@ 010,10 to 070,380 browse "TCBH" fields aTela
	@ 080,10 Say "Status Rotina: "+cStatus   SIZE 100, 7 Pixel Of oDlg2
	@ 090,10 Say "Ult.Importacao: "+cTempo   SIZE 100, 7 Pixel Of oDlg2	
	@ 090,350	bmpButton type 2 action close(oDlg2)

	activate dialog oDlg2

	dbSelectArea("TCBH")
	dbCloseArea()
	if file(cArq+".dbf")
		fErase(cArq+".dbf")
	endif

	RestArea(aArea)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcria_TCBH  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cria_TCBH()
	Local _nX
	
	dbSelectArea('SX3')
	dbSetOrder(1)
	For _nX := 1 To Len(_aArqSel)
		DbSeek(_aArqSel[_nX])
		While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
			if (alltrim(X3_CAMPO)+"," $cCampos)
				aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			endif
			dbSkip()
		endDo
	Next
	//aadd(aFields,{"C7_AQUANT","N",12,2})

	cArq:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq,"TCBH")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmonta_TC7 บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function monta_TCBH()
Local nX

	cQuery := " SELECT SUM(CBH_QTD) CBH_QTD, CBH_OP,CBH_OPERAC,CBH_RECUR,CBH_TIPO,RIGHT(MAX(CBH_DTFIM+CBH_HRFIM ),5) CBH_HRFIM, RIGHT(MIN(CBH_DTINI+CBH_HRINI  ),5) CBH_HRINI,
	cQuery += " COUNT(DISTINCT(CBH_OPERAD))CBH_OPERAD, MAX(CBH_DTFIM) CBH_DTFIM, MIN(CBH_DTINI) CBH_DTINI,  C2_QUANT
	cQuery += " FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) 
	cQuery += " INNER JOIN "+RetSqlName("SC2")+" C2 WITH(NOLOCK) ON  C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP 
	cQuery += " WHERE NOT EXISTS ( SELECT 'S'   FROM "+RetSqlName("SH6")+" WITH(NOLOCK) WHERE CBH_FILIAL = H6_FILIAL AND CBH_OP = H6_OP  AND D_E_L_E_T_ <> '*') 
	cQuery += " AND CBH.D_E_L_E_T_ <> '*'  AND CBH_OPERAC = '01' AND CBH_TRANSA = '02' AND CBH_DTFIM <> '' AND CBH_HRFIM <> ''  AND C2.D_E_L_E_T_ <> '*' 
	cQuery += " AND C2_QUANT > C2_QUJE  
	cQuery += " GROUP BY CBH_OP , CBH_FILIAL,CBH_OPERAC,CBH_RECUR,CBH_TIPO,C2_QUANT
	cQuery += " order by CBH_QTD DESC

	MemoWrite("MONTATCBH.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CAD", .F., .T.)

	TcSetField('CAD','CBH_DTINI','D')
	TcSetField('CAD','CBH_DTFIM','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem OPs em producao!","Aten็ใo")
		CAD->(dbCloseArea())
		Return
	EndIf

	dbSelectArea("CAD")
	dbGotop()
	ProcRegua(nRec1)


	while !Eof()
		incProc()
		recLock("TCBH",.T.)
		for nX := 1 to Len(aFields)
			if aFields[nX,2] ='C'
				cX :='TCBH->'+aFields[nX,1]+' :=alltrim(CAD->'+aFields[nX,1]+')'
			else
				cX :='TCBH->'+aFields[nX,1]+' :=CAD->'+aFields[nX,1]
			endif
			cX :=&cX
		next
		TCBH->(msUnLock())

		dbSelectArea("CAD")
		dbSkip()
	End
	CAD->(dbCloseArea())

	dbSelectarea("TCBH")
	dbGoTop()
	sysRefresh()
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDAT4ABASTบAutor  ณMicrosiga        บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSTATUS dos abastecimentosd	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ACDAT4ABAST(cOP)

	Local oDlgStat,oLocal
	Local dData 	:= dDataBase
	Local mm		:= 0

	Private aOPsB := {}
	Private oBListBox
	Private aFiltro 	:= {"Todos","Em Producao","Separacao","A Separar"}
	Private aOrdem 	:= {"Status","Data Emissao","OP","Buffer"}
	Private aLinha 	:= {"Chapa","Secador","Diversos","Todos"}
	Private cFiltro   := "Separacao"
	Private cLinha   := "Chapa"
	Private cOrdem	:= "Status"

	//QUANDO FOR PESQUISA DE OP NรO MOSTRA FILTRO
	If Empty(cOP)
		@ 65,153 To 229,435 Dialog oLocal Title OemToAnsi("Filtro Dados Sepracao")
		@ 09,09 Say OemToAnsi("Dados") Size 99,8 Pixel Of oLocal
		@ 09,49 COMBOBOX cFiltro ITEMS aFiltro  SIZE 55,9 Pixel Of oLocal
		@ 29,09 Say OemToAnsi("Ordena") Size 99,8 Pixel Of oLocal
		@ 29,49 COMBOBOX cOrdem ITEMS aOrdem  SIZE 55,9 Pixel Of oLocal
		@ 49,09 Say OemToAnsi("Linha") Size 99,8 Pixel Of oLocal
		@ 49,49 COMBOBOX cLinha ITEMS aLinha  SIZE 55,9 Pixel Of oLocal

		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oLocal)
		Activate Dialog oLocal Centered	
	EndIf

	//FILTRA OPS EM PROCESSO DE ABASTECIMENTO OU PRODUCAO
	cQuery := " SELECT CB7__PRESE, CB7_OP,ISNULL(CB7_CODOPE,'')CB7_CODOPE, ISNULL(CB1_NOME,'')CB1_NOME ,  CB7_DTEMIS , CB7_DTINIS ,  CB7_DTFIMS ,  CB7_STATUS , CB7__LCALI ,
	cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) CB7_HRINIS, "
	cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) CB7_HRFIMS,"
	cQuery += " ISNULL((SELECT TOP 1  CBH_RECUR  FROM CBH040 WHERE CBH_OP = CB7_OP AND CBH_FILIAL = CB7_FILIAL AND D_E_L_E_T_ <> '*' AND CBH_RECUR <> ''),'') CBH_RECUR,
	cQuery += " (SELECT C2__RECURS FROM "+RetSqlName("SC2")+" WHERE C2_NUM+C2_ITEM+C2_SEQUEN=CB7.CB7_OP AND D_E_L_E_T_ <> '*'  AND C2_QUJE < C2_QUANT AND C2_DATRF = '')C2__RECURS 
	cQuery += " FROM "+RetSqlName("CB7")+" CB7
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" CB1 ON CB1_FILIAL = CB7_FILIAL AND CB1_CODOPE = CB7_CODOPE AND CB1.D_E_L_E_T_ <> '*'	 
	cQuery += " WHERE CB7_DTEMIS >= '"+Dtos(dDatabase-60)+"' AND CB7.D_E_L_E_T_ <> '*'  AND CB7_OP <>'' 
	cQuery += " AND CB7_OP IN (SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM "+RetSqlName("SC2")+" WHERE C2_NUM+C2_ITEM+C2_SEQUEN=CB7.CB7_OP AND D_E_L_E_T_ <> '*'  AND C2_QUJE < C2_QUANT AND C2_DATRF = '')
	cQuery += " AND CB7_FILIAL = '"+xFilial("CB7")+"'
	If !Empty(cOP)
		cQuery += " AND CB7_OP = '"+cOP+"'" 
	EndIf

	MemoWrite("ACDAT4ABAST.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CAD", .F., .T.)

	TcSetField('CAD','CB7_DTINIS','D')
	TcSetField('CAD','CB7_DTFIMS','D')
	TcSetField('CAD','CB7_DTEMIS','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem OPs em Processo!","Aten็ใo")
		CAD->(dbCloseArea())
		Return
	EndIf

	dbSelectArea("CAD")
	dbGotop()
	ProcRegua(nRec1)


	while !Eof()
		incProc()
		//aOPs {01-STATUS, 02- ONDA, 03- OP, 04- COD OPER., 05-NOME OPER,06- DT GERACAO ONDA, 07- DATA INICIO SEP, 08- HORA INI SEP., 09-DATA FIM SEP., 10-HORA FIM SEP., 11- BUFFER, 12 - CEL PROD, 13-STATUS, 14- RECUSRSO OP
		If !Empty(CAD->CBH_RECUR) //EM PRODUCAO	
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cStatus := '5'
		ElseIf Empty(CAD->CBH_RECUR) .And. !Empty(CAD->CB7__LCALI) //AGUARDANDO INICIAR PRODUCAO
			cCor := LoadBitMap(GetResources(),"BR_AZUL")
			cStatus := '4'
		ElseIf Empty(CAD->CBH_RECUR) .And. Empty(CAD->CB7__LCALI) .And. CAD->CB7_STATUS == "9" //FALTA ENDERECAR BUFFER
			cCor := LoadBitMap(GetResources(),"BR_AMARELO")
			cStatus := '3'
		ElseIf Empty(CAD->CBH_RECUR) .And. Empty(CAD->CB7__LCALI) .And. CAD->CB7_STATUS == "1" //SEPARANDO
			cCor := LoadBitMap(GetResources(),"BR_CINZA")
			cStatus := '2'
		Else
			cCor := LoadBitMap(GetResources(),"BR_BRANCO")
			cStatus := '1'		
		EndIf

		//FILTROS
		If Empty(cOP)
			If (cFiltro == "Em Producao" .And.Empty(CAD->CBH_RECUR)) 
				dbSkip()
				Loop		
			EndIf


			If (cFiltro == "Separacao" .And. !(Empty(CAD->CBH_RECUR) .And. Empty(CAD->CB7__LCALI) .And. CAD->CB7_STATUS >= "1"))
				dbSkip()
				Loop		
			EndIf


			If(cFiltro == "A Separar" .And. !(Empty(CAD->CBH_RECUR) .And. Empty(CAD->CB7__LCALI) .And. CAD->CB7_STATUS = "0"))
				dbSkip()
				Loop		
			EndIf



			If (cLinha == "Chapa" .And. Left(CAD->C2__RECURS,3) # "CHP")
				dbSkip()
				Loop		
			EndIf

			If (cLinha == "Secador" .And. Left(CAD->C2__RECURS,3) # "SEC")
				dbSkip()
				Loop		
			EndIf

			If (cLinha == "Diversos" .And.  Left(CAD->C2__RECURS,3)# "DIV")
				dbSkip()
				Loop		
			EndIf
		EndIf


		aAdd(aOPsB,{cCor,CAD->CB7__PRESE, CAD->CB7_OP, CAD->CB7_CODOPE, CAD->CB1_NOME , CAD->CB7_DTEMIS , CAD->CB7_DTINIS , CAD->CB7_HRINIS , CAD->CB7_DTFIMS , CAD->CB7_HRFIMS ,  CAD->CB7__LCALI, CAD->CBH_RECUR,cStatus, CAD->C2__RECURS})

		dbSelectArea("CAD")
		dbSkip()
	End
	CAD->(dbCloseArea())

	If cOrdem =="Data Emissao"
		ASort(aOPsB,,,{|x,y|x[6]<y[6]})
	ElseIf cOrdem == "OP"
		ASort(aOPsB,,,{|x,y|x[3]<y[3]})
	ElseIf cOrdem =="Buffer"
		ASort(aOPsB,,,{|x,y|x[11]<y[11]})
	ElseIf cOrdem =="Status"
		ASort(aOPsB,,,{|x,y|x[13]<y[13]})
	EndIf

	If Len(aOPsB) == 0
		MsgStop("Nใo existem dados para o filtro selecionado!","ACDAT004")
		Return
	EndIf

	//MONTA TELA OPS SEM ONDA
	c2Fields := " "
	n2Campo 	:= 0

	//aOPs {01-STATUS, 02- ONDA, 03- OP, 04- COD OPER., 05-NOME OPER,06- DT GERACAO ONDA, 07- DATA INICIO SEP, 08- HORA INI SEP., 09-DATA FIM SEP., 10-HORA FIM SEP., 11- BUFFER, 12 - CEL PROD, 13-STATUS, 14- RECUSRSO OP
	aBTitCampos := {'',OemToAnsi("Onda"),OemToAnsi("OP"),OemToAnsi("Cod.Operador"),OemToAnsi("Nome"),OemToAnsi("Data Geracao"),OemToAnsi("Data Inicio"),OemToAnsi("Hora Inicio"),OemToAnsi("Data Fim"),OemToAnsi("Hora Fim"),OemToAnsi("Recurso OP"),OemToAnsi("Buffer"),OemToAnsi("Em Producao"),''}

	cBLine := "{aOPsB[oBListBox:nAT][1],aOPsB[oBListBox:nAT][2],aOPsB[oBListBox:nAT][3],aOPsB[oBListBox:nAT][4],aOPsB[oBListBox:nAT][5],aOPsB[oBListBox:nAT][6],aOPsB[oBListBox:nAT][7],aOPsB[oBListBox:nAT][8],aOPsB[oBListBox:nAT][9],aOPsB[oBListBox:nAT][10],aOPsB[oBListBox:nAT][14],aOPsB[oBListBox:nAT][11],aOPsB[oBListBox:nAT][12],}"

	bBLine := &( "{ || " + cBLine + " }" )
	nMult := 7
	aBCoord := {nMult*1,nMult*2,nMult*4,nMult*3,nMult*12,nMult*8,nMult*8,nMult*4,nMult*8,nMult*4,nMult*8,''}

	@050,005 TO 500,950  DIALOG oDlgStat TITLE "OPs em Processo"
	oBListBox := TWBrowse():New( 10,4,450,170,,aBTitCampos,aBCoord,oDlgStat,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBListBox:SetArray(aOPsB)
	oBListBox:bLDblClick := { ||Processa( {||WSAT02C(aOPsB[oBListBox:nAt,2]) }) }	
	oBListBox:bLine := bBLine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Em Produ็ใo" OF oDlgStat Color CLR_GREEN PIXEL

	@ 185, 065 BITMAP oBmp3 ResName 	"BR_BRANCO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "A Separar" OF oDlgStat Color CLR_RED PIXEL


	@ 185, 125 BITMAP oBmp3 ResName 	"BR_AMARELO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Sem BUFFER" OF oDlgStat Color CLR_RED PIXEL

	@ 185, 185 BITMAP oBmp3 ResName 	"BR_CINZA" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 195 SAY "Separando" OF oDlgStat Color CLR_RED PIXEL


	@ 185, 245 BITMAP oBmp2 ResName 	"BR_AZUL" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 255 SAY "Aguardando Inicio Producao" OF oDlgStat Color CLR_RED PIXEL

	@ 200,150 BUTTON "Excel"		SIZE 40,15 ACTION (U_ImpOlist(aBTitCampos,cBLine,oBListBox,"ACDAT4ABAST.CSV")) PIXEL OF oDlgStat
	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgStat:End() PIXEL OF oDlgStat

	ACTIVATE DIALOG oDlgStat CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpOlist  บAutor  ณPaulo Bindo         บ Data ณ  07/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณIMPRIME O CONTEUDO DO TWBROWSE                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบDesc.     ณEXP1: aTitCampos, ARRAY COM O CABECALHO                     บฑฑ
ฑฑบ          ณEXP2: CLINE, ITENS DO ACOLS                                 บฑฑ
ฑฑบ          ณEXP3: oListBox, NOME DO OBJETO                              บฑฑ
ฑฑบ          ณEXP4: NOME DO ARQUIVO A SER GERADO                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpOlist(aCamp,cLinha,oObjList,cArqExcel)
Local n
Local K

Private cArqTxt := "C:\EXCEL\"+cArqExcel
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"

MakeDir("C:\EXCEL\")

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//IMPRIME O CABECALHO
cLin    := ''
For n := 1 to Len(aCamp)
	
	cLin += aCamp[n]
	
	IF n == Len(aCamp)
		cLin += cEOL
	Else
		cLin += ';'
	EndIf
Next

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	ConOut("Ocorreu um erro na gravacao do arquivo.")
	dbCloseArea()
	fClose(nHdl)
	Return
Endif

//GRAVA ITENS
cLin    := ''
For n := 1 to oObjList:NLEN
	oObjList:NAT := n
	aTeste :=oObjList:AARRAY[n]
	cLin    := ''
	For K:=1 To Len(aTeste)
		If ValType(aTeste[K]) == "C"
			cLin += aTeste[K]
			
			IF K == Len(aTeste)
				cLin += cEOL
			Else
				cLin += ';'
			EndIf
		Else
			cLin += IIF(K == Len(aTeste),cEOL,';')
		EndIf
		
	Next
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif
	
Next

fClose(nHdl)
If ! ApOleClient( 'MsExcel' )
	ShellExecute("open",cArqTxt,"","", 1 )
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

If MsgYesNo("Deseja fechar a planilha do excel?")
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf

Return