#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTRL002  º Autor ³ Carlos Torres      º Data ³  19/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera consulta rastreabilidade do produto                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ESTRL002()
	Processa( {||ESTRL2()} )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDRD001  ºAutor  ³Microsiga           º Data ³  03/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ESTRL2()
	//Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	//Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	//Local oDlg
	Local oListBox
	//Local cListBox
	Local nOpc		:= 0
	//Local oBmp1
	//Local oBmp2//, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	//Local lMarca 	:= .F.
	//Local nNumDados	:= 0
	//Local j			:= 0
	Local nLoop		:= 0

	Private  Kx		:= 0
	Private aDados	:= {}
	Private oDlgPedidos
	Private aLogOS	:= {}
	Private cPerg	:= "ESTRL2"
	Private nQOP	:= 0
	Private nQItens	:= 0
	Private nQTItens:= 0
	Private oQOP, oQItens, oQTItens
	Private cPesqPV := Space(13)

	ValidPerg()
	If .NOT. Pergunte(cPerg,.T.)
		Return
	EndIf

	cQuery:= "SELECT  " + ENTER
	cQuery+= "	 CB7_ORDSEP	AS ORDEM_SEPARACAO " + ENTER
	cQuery+= "	 ,CB7_NOTA		AS NOTA_FISCAL " + ENTER
	cQuery+= "	 ,CB8_PEDIDO	AS PEDIDO_VENDA " + ENTER
	cQuery+= "	 ,CB8_ITEM		AS ITEM_PEDIDO " + ENTER
	cQuery+= "	 ,CB8_PROD		AS PRODUTO " + ENTER
	cQuery+= "	 ,ISNULL(ZA4_NUMSER,'')	AS SERIAL_DO_PRODUTO " + ENTER
	cQuery+= "	 ,ISNULL(ZA4_NCAIXA,'')	AS NUMERO_DA_CAIXA " + ENTER
	cQuery+= "	 ,ISNULL(ZA4_NLOTE,'')		AS PALLET " + ENTER
	cQuery+= "	 ,B1_DESC		AS DESCRICAO_PRODUTO " + ENTER
	cQuery+= "	 ,CB8_QTDORI	AS QT_ORIGINAL " + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_CLIORI = '' THEN SA1.A1_NOME ELSE SA1_SP.A1_NOME END) AS NOME_CLIENTE " + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_DTEMBA='' THEN '' ELSE CONVERT(VARCHAR(10),CONVERT(DATETIME,CB7_DTEMBA),103) END)	AS DT_EMBARQUE " + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_CLIORI = '' THEN SA1.A1_EST ELSE SA1_SP.A1_EST END) AS UF_CLIENTE " + ENTER
	cQuery+= "	 ,ISNULL(ZA4_NUMOP,'')		AS NUMERO_DA_OP " + ENTER
	cQuery+= "	 ,ISNULL(ZA4_DTFAB,'')		AS DATA_FABRICACAO " + ENTER
	cQuery+= "	 ,CB7_CODOPE	AS OPERADOR " + ENTER
	cQuery+= "FROM " + RetSqlName("CB7") + " CB7 WITH(NOLOCK) " + ENTER
	cQuery+= "INNER JOIN " + RetSqlName("CB8") + " CB8 WITH(NOLOCK) " + ENTER
	cQuery+= "	ON CB8_FILIAL=CB7_FILIAL " + ENTER
	cQuery+= "	AND CB8_ORDSEP=CB7_ORDSEP " + ENTER
	cQuery+= "	AND CB8.D_E_L_E_T_='' " + ENTER
	cQuery+= "	AND CB8_LOCAL IN ('21','22') " + ENTER
	cQuery+= "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH(NOLOCK) " + ENTER
	cQuery+= "	ON B1_FILIAL=CB7_FILIAL " + ENTER
	cQuery+= "	AND B1_COD=CB8_PROD " + ENTER
	cQuery+= "	AND SB1.D_E_L_E_T_='' " + ENTER
	cQuery+= "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 WITH(NOLOCK) " + ENTER
	cQuery+= "	ON A1_FILIAL=CB7_FILIAL " + ENTER
	cQuery+= "	AND A1_COD=CB7_CLIENT " + ENTER
	cQuery+= "	AND A1_LOJA=CB7_LOJA " + ENTER
	cQuery+= "	AND SA1.D_E_L_E_T_='' " + ENTER
	cQuery+= "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1_SP WITH(NOLOCK) " + ENTER
	cQuery+= "	ON SA1_SP.A1_FILIAL=CB7_FILIAL " + ENTER
	cQuery+= "	AND SA1_SP.A1_COD=CB7_CLIORI " + ENTER
	cQuery+= "	AND SA1_SP.A1_LOJA=CB7_LOJORI " + ENTER
	cQuery+= "	AND SA1_SP.D_E_L_E_T_='' " + ENTER
	cQuery+= "LEFT OUTER JOIN ZA4040 ZA4 WITH(NOLOCK) " + ENTER
	cQuery+= "	ON ZA4_ORDSEP=CB8_ORDSEP " + ENTER
	cQuery+= "	AND ZA4_FILIAL='02' " + ENTER
	cQuery+= "	AND ZA4_COD=CB8_PROD " + ENTER
	cQuery+= "	AND ZA4_PEDIDO=CB8_PEDIDO " + ENTER
	cQuery+= "	AND ZA4.D_E_L_E_T_='' " + ENTER
	cQuery+= "WHERE CB7.D_E_L_E_T_='' " + ENTER
	cQuery+= "	AND CB7_FILIAL='" + xFilial("CB7") + "'" + ENTER
	If !EMPTY(mv_par01)
		cQuery+= "	AND RIGHT(ZA4_DTFAB,4)='" + ALLTRIM(mv_par01) + "'" + ENTER
	EndIf
	If !EMPTY(mv_par02)
		cQuery+= "	AND ZA4_NLOTE='" + ALLTRIM(mv_par02) + "'" + ENTER
	EndIf
	If !EMPTY(mv_par03)
		cQuery+= "	AND CB8_NOTA='" + ALLTRIM(mv_par03) + "' " + ENTER
	EndIf
	If !EMPTY(mv_par04)
		cQuery+= "	AND ZA4_COD='" + ALLTRIM(mv_par04) + "'" + ENTER
	EndIf
	cQuery+= "ORDER BY CB7_ORDSEP,CB8_ITEM " + ENTER

	MemoWrite("ESTRL002_RELATORIO_RASTREABILIDADE.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBCB7', .F., .T.)

	Count To nRecCB7

	ProcRegua(nRecCB7)

	aDados	 := {}

	TRBCB7->(DbGotop())
	While !TRBCB7->(Eof())

		IncProc("Montando os itens a serem selecionados")

		aAdd(aDados,{TRBCB7->ORDEM_SEPARACAO,TRBCB7->NOTA_FISCAL,TRBCB7->PEDIDO_VENDA,TRBCB7->ITEM_PEDIDO,TRBCB7->PRODUTO,TRBCB7->SERIAL_DO_PRODUTO,TRBCB7->NUMERO_DA_CAIXA,TRBCB7->PALLET,TRBCB7->DESCRICAO_PRODUTO,TRBCB7->QT_ORIGINAL,TRBCB7->NOME_CLIENTE,TRBCB7->DT_EMBARQUE,TRBCB7->UF_CLIENTE,TRBCB7->NUMERO_DA_OP,TRBCB7->DATA_FABRICACAO,TRBCB7->OPERADOR})

		TRBCB7->(DbSkip())
	End

	If Len(aDados) == 0
		MsgStop("Não existem dados para esta selecao!","Atenção")
		Return
	EndIf


	//MONTA O CABECALHO

	aTitCampos := {OemToAnsi("ORDEM_SEPARACAO"),OemToAnsi("NOTA_FISCAL"),OemToAnsi("PEDIDO_VENDA"),OemToAnsi("ITEM_PEDIDO"),OemToAnsi("PRODUTO"),OemToAnsi("SERIAL_DO_PRODUTO"),OemToAnsi("NUMERO_DA_CAIXA"),OemToAnsi("PALLET"),OemToAnsi("DESCRICAO_PRODUTO"),OemToAnsi("QT_ORIGINAL"),OemToAnsi("NOME_CLIENTE"),OemToAnsi("DT_EMBARQUE"),OemToAnsi("UF_CLIENTE"),OemToAnsi("NUMERO_DA_OP"),OemToAnsi("DATA_FABRICACAO"),OemToAnsi("OPERADOR"),''}

	cLine := "{"
	For nLoop:=1 to 16
		cLine += " aDados[oListBox:nAT][" + str(nLoop) + "],"
	Next
	cLine += " }"

	bLine := &( "{ || " + cLine + " }" )
	nMult := 7
	aCoord2 := {nMult*1,nMult*1,nMult*6,nMult*6,nMult*8,nMult*6}

	@ 100,005 TO 600,950 DIALOG oDlgPedidos TITLE "Rastreabilidade"

	oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLine := bLine

	@ 220,110 BUTTON "Exportar"	   		SIZE 40,15 ACTION {ExpExcel()}  PIXEL OF oDlgPedidos
	@ 220,210 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	ACTIVATE DIALOG oDlgPedidos CENTERED


	If nOpc == 0
		Return
	EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Paulo Bindo         º Data ³  12/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria pergunta no e o help do SX1                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

	//PutSx1(cGrupo,cOrdem,cPergunt            ,cPerSpa               ,cPerEng               ,cVar ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid	,cF3	, cGrpSxg ,cPyme,cVar01    ,cDef01     		,cDefSpa1,cDefEng1,cCnt01,cDef02  				,cDefSpa2,cDefEng2,cDef03	,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Ano de Fabricacao  ?",""                    ,""                    ,"mv_ch1","C"   ,04      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par01",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Nº do Lote         ?",""                    ,""                    ,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par02",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Nº da Nota Fiscal  ?",""                    ,""                    ,"mv_ch3","C"   ,09      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par03",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Do Produto         ?",""                    ,""                    ,"mv_ch4","C"   ,15      ,0       ,0      , "G",""    ,"SB1" 	,""      ,""   ,"mv_par04",""         		,""      ,""      ,""    ,""      			,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P.ESTRL101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o ano de fabricacao ")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.ESTRL102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número do lote ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.ESTRL103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número da nota fiscal    ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.ESTRL104."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o produto ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ExpExcel  ³ Autor ³ Microsiga             ³ Data ³ 13/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exporta para o excel simulacao                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExpExcel()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Local nTamLin
	// Local cLin
	// Local cCpo
	Local cDirDocs  := MsDocPath()
	//Local cError 	:= ""
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "SIMUL_SEPARACAO.CSV"
	Local oExcelApp
	//Local nHandle
	// Local cCrLf 	:= Chr(13) + Chr(10)
	// Local nX
	// Local nTotEnd 	:= 0
	Local Kx		:= 0	
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"


	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("Não foi possível abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
	cLin := "SIMULACAO SEPARACAO"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin    :=     OemToAnsi("ORDEM_SEPARACAO")+';'+OemToAnsi("NOTA_FISCAL")+';'+OemToAnsi("PEDIDO_VENDA")+';'+OemToAnsi("ITEM_PEDIDO")+';'+OemToAnsi("PRODUTO")+';'+OemToAnsi("SERIAL_DO_PRODUTO")+';'+OemToAnsi("NUMERO_DA_CAIXA")+';'+OemToAnsi("PALLET")+';'+OemToAnsi("DESCRICAO_PRODUTO")+';'+OemToAnsi("QT_ORIGINAL")+';'+OemToAnsi("NOME_CLIENTE")+';'+OemToAnsi("DT_EMBARQUE")+';'+OemToAnsi("UF_CLIENTE")+';'+OemToAnsi("NUMERO_DA_OP")+';'+OemToAnsi("DATA_FABRICACAO")+';'+OemToAnsi("OPERADOR")
	cLin += cEOL //ULTIMO ITEM

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(a2ItOPs))

	TRBCB7->(DbGotop())
	While !TRBCB7->(Eof())

		IncProc("Montando os itens a serem selecionados")

		aAdd(aDados,{TRBCB7->ORDEM_SEPARACAO,TRBCB7->NOTA_FISCAL,TRBCB7->PEDIDO_VENDA,TRBCB7->ITEM_PEDIDO,TRBCB7->PRODUTO,TRBCB7->SERIAL_DO_PRODUTO,TRBCB7->NUMERO_DA_CAIXA,TRBCB7->PALLET,TRBCB7->DESCRICAO_PRODUTO,TRBCB7->QT_ORIGINAL,TRBCB7->NOME_CLIENTE,TRBCB7->DT_EMBARQUE,TRBCB7->UF_CLIENTE,TRBCB7->NUMERO_DA_OP,TRBCB7->DATA_FABRICACAO,TRBCB7->OPERADOR})
		


			cLin    := ''
			cLin    += a2ItOPs[Kx][1]+';'

			//PULA LINHA
			cLin += cEOL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
			//³ linha montada.                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				ConOut("Ocorreu um erro na gravacao do arquivo.")
				fClose(nHdl)
				Return
		Endif
		TRBCB7->(DbSkip())
	End

	//PULA LINHA
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
		cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
		cF3, cGrpSxg,cPyme,;
		cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
		cDef02,cDefSpa2,cDefEng2,;
		cDef03,cDefSpa3,cDefEng3,;
		cDef04,cDefSpa4,cDefEng4,;
		cDef05,cDefSpa5,cDefEng5,;
		aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f.


	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
