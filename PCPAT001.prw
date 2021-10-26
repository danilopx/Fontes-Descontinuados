#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCPAT001  บ Autor ณ PAULO BINOD        บ Data ณ  12/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA PARA GERENCIAMENTO DA PRODUCAO                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PCPAT001()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local cListBox
	Local nOpc		:= 0 
	Local nF4For
	Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local lCampos 	:= .F.
	Local cPedido	:= Space(08)
	Local cNFilial	:= Space(02)
	Local cPedCli	:= Space(15)
	Local cCliente	:= Space(06)

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
	Private aCelsCHP	:= {}		// CELULAS CHAPA
	Private aCelsSEC	:= {}		// CELULAS SECADOR
	Private aCelsDIV	:= {}		// CELULAS DIVERSOS
	Private aNumPed		:= {}		//NUMERO PEDIDOS
	Private aNumFat		:= {}		//NUMERO NOTAS
	Private aFats 	:= {}		// FATURAMENTO SEM SEPARACAO
	Private aOnda 	:= {}		//ONDAS EM ABERTO
	Private aAtraso := {}	//PEDIDOS IMPRESSOS E NAO FATURADOS
	Private nNotasF := 0	//NOTAS FATURA
	Private nNotasR := 0	//NOTAS REMESSA
	Private nValF	:= 0	//TOTAL FATURA
	Private nValR	:= 0	//TOTAL REMESSA
	Private nItensS := 0	//SOMA DOS ITENS FATURADOS
	Private nItensD := 0	//ITENS DISTINTOS
	Private l20 	:= .F.


	Cursorwait()
	RelerTerm()
	CursorArrow()



	@100,005 TO 600,950  DIALOG oDlgNotas TITLE "Controle Produ็ใo"

	//MONTA TELA SECADOR
	c1Fields := " "
	n1Campo 	:= 0

	//01-STATUS PRODUTIVIDADE, 02-STATUS ABASTECIMENTO, 03-CELULA, 04- OP EM PRODUCAO, 05-PORC.PRODUZIDA, 06-PRODUTO
	a1TitCampos := {OemToAnsi("P"),OemToAnsi("A"),OemToAnsi("Celula"),OemToAnsi("OP"),OemToAnsi("% Prod."),OemToAnsi("Produto"),''}

	c1Line := "{aCelsSEC[o1ListBox:nAT][1],aCelsSEC[o1ListBox:nAT][2],aCelsSEC[o1ListBox:nAT][3],aCelsSEC[o1ListBox:nAT][4],aCelsSEC[o1ListBox:nAT][5],aCelsSEC[o1ListBox:nAT][6],}"

	b1Line := &( "{ || " + c1Line + " }" )
	nMult := 7
	aCoord := {nMult*1,nMult*1,nMult*3,nMult*5,nMult*3,nMult*6,''}


	@ 5,2 TO 160,135 LABEL "Secador" OF oDlgNotas  PIXEL
	o1ListBox := TWBrowse():New( 17,4,130,140,,a1TitCampos,aCoord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o1ListBox:SetArray(aCelsSEC)
	o1ListBox:bLDblClick := { ||ShellExecute("open","http://producao/IndiceProducao/IndiceProducaoPorCelula.aspx?nomeCelula="+aCelsSEC[o1ListBox:nAT][3],"","",1) }
	o1ListBox:bLine := b1Line


	//MONTA TELA CHAPINHA
	//01-STATUS PRODUTIVIDADE, 02-STATUS ABASTECIMENTO, 03-CELULA, 04- OP EM PRODUCAO, 05-PORC.PRODUZIDA, 06-PRODUTO
	a2TitCampos := {OemToAnsi("P."),OemToAnsi("A."),OemToAnsi("Celula"),OemToAnsi("OP"),OemToAnsi("% Prod."),OemToAnsi("Produto"),''}

	c2Line := "{aCelsCHP[o2ListBox:nAT][1],aCelsCHP[o2ListBox:nAT][2],aCelsCHP[o2ListBox:nAT][3],aCelsCHP[o2ListBox:nAT][4],aCelsCHP[o2ListBox:nAT][5],aCelsCHP[o2ListBox:nAT][6],}"

	b2Line := &( "{ || " + c2Line + " }" )
	nMult := 7
	a2Coord := {nMult*1,nMult*1,nMult*3,nMult*5,nMult*3,nMult*6,''}

	@ 5,148 TO 160,285 LABEL "Chapas" OF oDlgNotas  PIXEL
	o2ListBox := TWBrowse():New( 17,150,130,140,,a2TitCampos,a2Coord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o2ListBox:SetArray(aCelsCHP)
	o2ListBox:bLDblClick := { ||ShellExecute("open","http://producao/IndiceProducao/IndiceProducaoPorCelula.aspx?nomeCelula="+aCelsCHP[o2ListBox:nAT][3],"","",1)} 
	o2ListBox:bLine := b2Line

	//MONTA TELA DIVERSOS
	//01-STATUS PRODUTIVIDADE, 02-STATUS ABASTECIMENTO, 03-CELULA, 04- OP EM PRODUCAO, 05-PORC.PRODUZIDA, 06-PRODUTO
	a3TitCampos := {OemToAnsi("P."),OemToAnsi("A."),OemToAnsi("Celula"),OemToAnsi("OP"),OemToAnsi("% Prod."),OemToAnsi("Produto"),''}

	c3Line := "{aCelsCHP[o3ListBox:nAT][1],aCelsDIV[o3ListBox:nAT][2],aCelsDIV[o3ListBox:nAT][3],aCelsDIV[o3ListBox:nAT][4],aCelsDIV[o3ListBox:nAT][5],aCelsDIV[o3ListBox:nAT][6],}"

	b3Line := &( "{ || " + c3Line + " }" )
	nMult := 7
	a3Coord := {nMult*1,nMult*1,nMult*3,nMult*5,nMult*3,nMult*6,''}

	@ 5,294 TO 160,435 LABEL "Diversos" OF oDlgNotas  PIXEL
	o3ListBox := TWBrowse():New( 17,296,130,140,,a3TitCampos,a3Coord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o3ListBox:SetArray(aCelsDIV)
	o3ListBox:bLDblClick := { ||ShellExecute("open","http://producao/IndiceProducao/IndiceProducaoPorCelula.aspx?nomeCelula="+aCelsDIV[o3ListBox:nAT][3],"","",1)}
	o3ListBox:bLine := b3Line

	@ 165, 005 SAY "P - Produtividade" OF oDlgNotas Color CLR_BLACK PIXEL

	@ 165, 075 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 085 SAY "100 +/- 3%" OF oDlgNotas Color CLR_GREEN PIXEL

	@ 165, 150 BITMAP oBmp2 ResName 	"BR_AMARELO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 165 SAY "100 +/- 4~5%" OF oDlgNotas Color CLR_RED PIXEL

	@ 165, 210 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 225 SAY "100 Abaixo 6%" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 005 SAY "A - Abastecimento" OF oDlgNotas Color CLR_BLACK PIXEL

	@ 175, 075 BITMAP oBmp3 ResName 	"BR_PRETO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 085 SAY "Encerrada" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 150 BITMAP oBmp4 ResName 	"BR_AZUL" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 165 SAY "Pendente" OF oDlgNotas Color CLR_RED PIXEL
	/*
	//busca de pedidos
	@ 160,130 Say OemToAnsi("Filial + Ped.Taiff") Size 99,6 Of oDlgNotas Pixel
	@ 160,180 MSGet cPedido Picture "@!" Size 59,8 Of oDlgNotas Pixel 

	@ 172,130 Say OemToAnsi("Ped.Cliente") Size 99,8 Of oDlgNotas Pixel
	@ 172,180 MSGet cPedCli  Size 59,8 Of oDlgNotas Pixel

	@ 172,250 Say OemToAnsi("Cliente") Size 99,8 Of oDlgNotas Pixel
	@ 172,270 MSGet cCliente Picture "@!" F3 "SA1" Size 59,8 Of oDlgNotas Pixel

	@ 172,340 Say OemToAnsi("Filial") Size 99,6 Of oDlgNotas Pixel
	@ 172,355 MSGet cNFilial Picture "@!" F3 "SM0" Size 30,8 Of oDlgNotas Pixel

	@ 172,389 BUTTON "Busca"   	SIZE 20,10 ACTION (U_BuscCliPed(cPedido,cNFilial,cPedCli,cCliente),cPedido:= Space(08),cNFilial:= Space(02),cPedCli:= Space(15),cCliente:= Space(06),oDlgNotas:Refresh()) PIXEL OF oDlgNotas
	*/


	@ 015,440  SAY oCrono VAR cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgNotas


	@ 185,2 TO 210,460 LABEL "Totaliza็ใo Diแria" OF oDlgNotas  PIXEL
	/*
	@ 190, 005 SAY "Notas Remessa" OF oDlgNotas Color CLR_RED PIXEL
	@ 190, 070 SAY Transform(nNotasR,"@e 99999") OF oDlgNotas Color CLR_RED PIXEL
	@ 198, 005 SAY "R$ Total Remessa" OF oDlgNotas Color CLR_RED PIXEL
	@ 198, 055 SAY Transform(nValR,"@e 9,999,999.99") OF oDlgNotas Color CLR_RED PIXEL

	@ 190, 115 SAY "Notas Fatura" OF oDlgNotas Color CLR_BLUE PIXEL
	@ 190, 170 SAY Transform(nNotasF,"@e 99999") OF oDlgNotas Color CLR_BLUE PIXEL
	@ 198, 115 SAY "R$ Total Fatura" OF oDlgNotas Color CLR_BLUE PIXEL
	@ 198, 155 SAY Transform(nValF,"@e 9,999,999.99") OF oDlgNotas Color CLR_BLUE PIXEL

	//@ 190, 225 SAY "Soma Itens" OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 190, 275 SAY Transform(nItensS,"@e 99999") OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 198, 225 SAY "Itens Distintos" OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 198, 275 SAY Transform(nItensD,"@e 99999") OF oDlgNotas Color CLR_GREEN PIXEL
	*/
	dbSelectArea("SM0")
	//If U_CHECAFUNC(RetCodUsr(),"ACDAT005") .Or. cFilAnt # "02"
	@ 210,005 BUTTON "Rel.Apontamento"    	SIZE 40,15 ACTION (U_PCPHRIMPR(),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	@ 210,050 BUTTON "Monitor"			   	SIZE 40,15 ACTION ( ACDA080()) PIXEL OF oDlgNotas
	@ 210,095 BUTTON "Rel.Divergencia"    	SIZE 40,15 ACTION (U_PCPHOROPE(),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	//	@ 210,095 BUTTON "Impr.Onda"   		SIZE 40,15 ACTION (Processa( {||ImpPOnda(aOnda[o1ListBox:nAt,2]) } ),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	//@ 210,095 BUTTON "Caixaria"   		SIZE 40,15 ACTION (U_WS02CAIXA(aOnda[o1ListBox:nAt,2])) PIXEL OF oDlgNotas
	@ 210,140 BUTTON "Atualizar"    	SIZE 40,15 ACTION {WSAT2AtuCro(2)} PIXEL OF oDlgNotas
	//@ 210,185 BUTTON "Cancelar Onda"	SIZE 40,15 ACTION {Processa( {|| WSAT2EST() } ),nOpc :=1,oDlgNotas:End()} PIXEL OF oDlgNotas
	//@ 210,230 BUTTON "Risca FDE"		SIZE 40,15 ACTION (Processa( {||U_RiscaFDE()})) PIXEL OF oDlgNotas
	//@ 210,275 BUTTON "Prev.Pedidos"		SIZE 40,15 ACTION (Processa( {||U_PedidosCD()})) PIXEL OF oDlgNotas
	//	@ 210,320 BUTTON "Risca Item"		SIZE 40,15 ACTION (U_RiscaItem()) PIXEL OF oDlgNotas
	//	@ 210,365 BUTTON "Lib./Trav.Sep." 		SIZE 40,15 ACTION {U_A005LibOnda(aOnda[o1ListBox:nAt,2],"S",aOnda[o1ListBox:nAt,13])} PIXEL OF oDlgNotas
	//@ 210,410 BUTTON "Lib./Trav.Pre." 		SIZE 40,15 ACTION {U_LibOnda(aOnda[o1ListBox:nAt,2],"P",aOnda[o1ListBox:nAt,12])} PIXEL OF oDlgNotas

	//@ 230,005 BUTTON "Ped.Pendentes"   	SIZE 40,15 ACTION (Processa( {||ImpPedPend() } ),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	//@ 230,050 BUTTON "Rel.Abastec."		SIZE 40,15 ACTION (U_WS02ABAST()) PIXEL OF oDlgNotas
	//EndIf

	//@ 230,095 BUTTON "Acomp.Separ." 	SIZE 40,15 ACTION {U_A005WMACOMP(aOnda[o1ListBox:nAt,2])} PIXEL OF oDlgNotas
	//@ 230,140 BUTTON "Acomp.Pre." 		SIZE 40,15 ACTION {U_A005WMSPCACOMP(aOnda[o1ListBox:nAt,2],"P")} PIXEL OF oDlgNotas
	//@ 230,185 BUTTON "Acomp.Chk." 		SIZE 40,15 ACTION {U_A005WMSPCACOMP(aOnda[o1ListBox:nAt,2],"C")} PIXEL OF oDlgNotas
	//@ 230,230 BUTTON "Rel.Produt." 		SIZE 40,15 ACTION {U_A005WMSRL001()} PIXEL OF oDlgNotas
	//@ 230,275 BUTTON "Rel.Sobra." 		SIZE 40,15 ACTION {U_A005WSAT02SB(aOnda[o1ListBox:nAt,2]),oDlgNotas:Refresh()} PIXEL OF oDlgNotas
	//@ 230,320 BUTTON "ALERTA"	 		SIZE 40,15 ACTION {U_A005ALERTAONDA()} PIXEL OF oDlgNotas

	//If U_CHECAFUNC(RetCodUsr(),"ACDAT005") .Or. cFilAnt # "02"
	//@ 230,365 BUTTON "Libera Trava" 	SIZE 40,15 ACTION {PutMv("MV__ACDRD2","N")} PIXEL OF oDlgNotas
	//EndIf
	@ 230,410 BUTTON "Sair"        		SIZE 40,15 ACTION {nOpc :=0,oDlgNotas:End()} PIXEL OF oDlgNotas



	oTimer := TTimer():New( 10 * 1000, {||WSAT2AtuCro(1)  }, oDlgNotas )
	oTimer:lActive   := .T. // para ativar

	ACTIVATE DIALOG oDlgNotas CENTERED


	If nOpc == 1
		U_PCPAT001()
	EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
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


	cQuery := " SELECT H1_CODIGO ,ISNULL(CBH_OP,'')CBH_OP,ISNULL(LEFT(CBH_HRFIM,2),'')CBH_HRFIM,

	cQuery += " ISNULL((SELECT C2__QTDENG FROM "+RetSqlName("SC2")+" C2 WHERE C2_FILIAL= CBH_FILIAL AND C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP AND D_E_L_E_T_ <> '*' ),0) C2__QTDENG ,
	
	cQuery += " ISNULL((SELECT 'S' FROM "+RetSqlName("CB7")+" CB7 WHERE CB7_FILIAL = CBH_FILIAL AND CBH_OP <> CB7_OP AND CB7_STATUS <> '9' AND 
	cQuery += " CB7_OP IN (SELECT TOP 1 C2_NUM+C2_ITEM+C2_SEQUEN FROM "+RetSqlName("SC2")+" C2 WITH(NOLOCK) WHERE CB7_FILIAL = C2_FILIAL AND C2__RECURS = H1_CODIGO AND C2.D_E_L_E_T_ <> '*' ORDER BY C2_PRIOR  )AND CB7.D_E_L_E_T_ <> '*'),'N') SEPARACAO,

	cQuery += " ISNULL((SELECT C2_PRODUTO  FROM "+RetSqlName("SC2")+" C2 WHERE C2_FILIAL= CBH_FILIAL AND C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP AND D_E_L_E_T_ <> '*' ),0) C2_PRODUTO ,

	cQuery += " ISNULL((SELECT TOP 1 CBH_HRFIM FROM "+RetSqlName("CBH")+" CBH2 WITH(NOLOCK) WHERE CBH2.CBH_OP = CBH.CBH_OP AND  CBH2.D_E_L_E_T_ <> '*' AND LEFT(CBH2.CBH_HRFIM,2) = LEFT(CBH.CBH_HRFIM,2)
	cQuery += " AND LEFT(CBH2.CBH_DTFIM,2) = LEFT(CBH.CBH_DTFIM,2) AND CBH2.CBH_OPERAC = CBH.CBH_OPERAC AND CBH2.CBH_TRANSA = CBH.CBH_OPERAC
	cQuery += " ORDER BY CBH_HRFIM DESC ),'')CBH_HRFIM2,

	cQuery += " ISNULL((SELECT SUM(CBH_QTD) FROM "+RetSqlName("CBH")+" CBH2 WITH(NOLOCK) WHERE CBH2.CBH_OP = CBH.CBH_OP AND  CBH2.D_E_L_E_T_ <> '*' AND LEFT(CBH2.CBH_HRFIM,2) = LEFT(CBH.CBH_HRFIM,2)
	cQuery += " AND LEFT(CBH2.CBH_DTFIM,2) = LEFT(CBH.CBH_DTFIM,2)  AND CBH2.CBH_OPERAC = CBH.CBH_OPERAC AND CBH2.CBH_TRANSA = CBH.CBH_OPERAC),0)CBH_QTD,

	cQuery += " (SELECT COUNT(DISTINCT(CBH_OPERAD)) FROM "+RetSqlName("CBH")+" CBH2 WITH(NOLOCK) WHERE CBH2.CBH_OP = CBH.CBH_OP AND  CBH2.D_E_L_E_T_ <> '*' AND LEFT(CBH2.CBH_HRFIM,2) = LEFT(CBH.CBH_HRFIM,2)
	cQuery += " AND LEFT(CBH2.CBH_DTFIM,2) = LEFT(CBH.CBH_DTFIM,2) AND CBH2.CBH_OPERAC = CBH.CBH_OPERAC AND CBH2.CBH_TRANSA = CBH.CBH_OPERAC) CBH_OPERAD

	cQuery += " FROM "+RetSqlName("SH1")+" H1 WITH(NOLOCK)
	cQuery += " LEFT JOIN "+RetSqlName("CBH")+" CBH WITH(NOLOCK) ON CBH_RECUR = H1_CODIGO AND CBH_FILIAL = H1_FILIAL  AND CBH.D_E_L_E_T_ <> '*' AND CBH_OPERAC = '01' AND CBH_TRANSA = '02'
	cQuery += " AND LEFT(CBH_HRFIM,2) = right(replicate('0',2) + CONVERT(VARCHAR(2),DATEPART(HOUR,GETDATE())),2) 
	cQuery += " AND CBH_DTFIM = '"+Dtos(dDataBase)+"'
	cQuery += " WHERE H1.D_E_L_E_T_ <> '*' AND LEFT(H1_CODIGO,3) IN ('CHP','SEC','DIV')
	//USADO PARA TESTES
	//cQuery += " AND H1_CODIGO = 'SEC10 '
	cQuery += " GROUP BY H1_CODIGO ,CBH_OP,LEFT(CBH_HRFIM,2),CBH_DTFIM,CBH_OPERAC, CBH_FILIAL 
	cQuery += " ORDER BY H1_CODIGO, LEFT(CBH_HRFIM,2) DESC




	CONOUT("SELECIONA CELULAS E OPS ")
	MemoWrite("PCPAT001.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)


	Count To nRec1
	CursorArrow()

	aCels := {}
	If nRec1 == 0
		//01-STATUS PRODUTIVIDADE, 02-STATUS ABASTECIMENTO, 03-CELULA, 04- OP EM PRODUCAO, 05-PORC.PRODUZIDA, 06-PRODUTO
		aAdd(aCelsCHP,{'','','','',0,'',''})
		aAdd(aCelsSEC,{'','','','',0,'',''})
		aAdd(aCelsDIV,{'','','','',0,'',''})
	Else

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()

			dbSelectArea("SC2")
			dbSetOrder(1)
			If dbSeek(xFilial()+TRB->CBH_OP)
				nQuant := SC2->C2_QUANT
				nQuje  := SC2->C2__QTDH6
				nPProd := Round((SC2->C2__QTDH6/SC2->C2_QUANT)*100,0)
			Else
				nPProd := 0
			EndIf

			//CALCULO PRODUTIVIDADE
			//1) NUMERO PECAS POR HORA X NUMERO OPERADORES
			nPecasH := TRB->C2__QTDENG * TRB->CBH_OPERAD
			//2) TRANFORMA MINUTOS EM DECIMAL
			nTempo := Val(SubStr(TRB->CBH_HRFIM2,4,2))*0.01667
			//3) REGRA DE TRES PARA CALCULO PECAS FEITAS NA HORA ATUAL
			nCalcPc :=  nPecasH * nTempo
			//4) CALCULO PORCENTAGEM PRODUZIDA SOBRE A QUANTIDADE DA ENGENHARIA
			nPorc := (nCalcPc/nPecasH)*100

			//PRODUTIVIDADE
			cBitMap := Iif(nPorc >= 100,LoadBitMap(GetResources(),"BR_VERDE"), Iif(nPorc >= 95,LoadBitMap(GetResources(),"BR_AMARELO"),LoadBitMap(GetResources(),"BR_VERMELHO"))   )
			//SEPARACAO
			c2BitMap := Iif(TRB->SEPARACAO == "S",LoadBitMap(GetResources(),"BR_PRETO"   ),LoadBitMap(GetResources(),"BR_AZUL"))

			If  Left(TRB->H1_CODIGO,3) == "CHP"				
				aAdd(aCelsCHP,{cBitMap,c2BitMap,TRB->H1_CODIGO,TRB->CBH_OP,nPProd,TRB->C2_PRODUTO})
			ElseIf  Left(TRB->H1_CODIGO,3) == "SEC"
				aAdd(aCelsSEC,{cBitMap,c2BitMap,TRB->H1_CODIGO,TRB->CBH_OP,nPProd,TRB->C2_PRODUTO})
			ElseIf  Left(TRB->H1_CODIGO,3) == "DIV"
				aAdd(aCelsDIV,{cBitMap,c2BitMap,TRB->H1_CODIGO,TRB->CBH_OP,nPProd,TRB->C2_PRODUTO})
			EndIf

			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())
	If Len(aCelsCHP)==0
		aAdd(aCelsCHP,{'','','','',0,'',''})
	EndIf
	If Len(aCelsSEC) ==0
		aAdd(aCelsSEC,{'','','','',0,'',''})
	EndIf
	If Len(aCelsDIV) ==0
		aAdd(aCelsDIV,{'','','','',0,'',''})
	EndIf

return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
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
		U_PCPAT001()

	EndIf

	cCrono := cTimeAtu
	oCrono:Refresh()


Return(.T.)





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
User Function PAT1WMACOMP(cOnda)

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
User Function PAT1WMSPCACOMP(cOnda,cOpc)

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
User Function PAT1WMAT02EXC()
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
	Local Kx		:= 0
	Local nTotEnd := 0
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
User Function PAT1ACOSEPPROD(cNomOper)
	Local oDlgOper
	Local a2Oper := {}
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Local Kx 		:= 0

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
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  02/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PAT1Pausa(cPOrdSep)

	cQuery := " UPDATE "+RetSqlName("CB7")+" SET CB7_STATPA = '1' WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7_ORDSEP = '"+cPOrdSep+"' AND D_E_L_E_T_ <> '*'"

	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualiza็ใo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf

	MsgInfo("Em Pausa!","ACDAT005")

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
User Function PAT1AtuPre()
	Local Kx := 0
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

	MemoWrite("ACDAT00516.SQL",cQuery)
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
User Function PAT1AtuSep()
	Local Kx := 0
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

	MemoWrite("ACDAT00515.SQL",cQuery)
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
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PAT1LibOnda(cLOnda,cOper,cTrava)

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
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PAT1AlertaOnda()
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
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PAT1ALWSAT02()
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
		MsgAlert("Nใo existem operadores trabalhando no momento!","ACDAT005")
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
ฑฑบPrograma  ณACDAT005  บAutor  ณMicrosiga           บ Data ณ  03/10/11   บฑฑ
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





