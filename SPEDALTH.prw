#Include 'Totvs.ch'
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER Chr(13)+Chr(10)

User Function SPEDALTH()
	Local dDataFec := PARAMIXB[1]
	Local cMotInv := PARAMIXB[2]
	Local cAliBLH := ''
	Local cArqP7 := ''
	Local nH
	Local nTamCli := TamSX3("A1_COD" )[1]
	Local nTamLoj := TamSX3("A1_LOJA")[1]
	Local cCliefor := ""
	Local cLoja := ""
	Local cAlias := ""
	Local cIndTmp1 := ""
	
	Local cQuery := ""
	
	
	cQuery := "SELECT " + ENTER
	cQuery += "	FILIAL" + ENTER
	cQuery += "	,SITUACAO " + ENTER
	cQuery += "	,PRODUTO " + ENTER
	cQuery += "	,UM " + ENTER
	cQuery += "	,QTD_ARM " + ENTER
	cQuery += "	,VAL_ARM " + ENTER
	cQuery += "	,TOT_ARM " + ENTER
	cQuery += "	,ARMAZEM " + ENTER
	cQuery += "	,CLIFOR " + ENTER
	cQuery += "	,LOJA " + ENTER
	cQuery += "	,TPCF " + ENTER
	cQuery += "	,CONTA " + ENTER
	If CEMPANT="03" .AND. CFILANT = "01"
		cQuery += "FROM SPED_2017123103_01 " + ENTER
	ElseIf CEMPANT="03" .AND. CFILANT = "02"
		cQuery += "FROM SPED_2017123103_02 " + ENTER
	ElseIf CEMPANT="04" .AND. CFILANT = "02"
		cQuery += "FROM SPED_2017123104_02 " + ENTER
	ElseIf CEMPANT="04" .AND. CFILANT = "01"
		cQuery += "FROM SPED_2017123104_01 " + ENTER
	ElseIf CEMPANT="01"
		cQuery += "FROM SPED_2017123101_02 " + ENTER
	EndIf
	
	MemoWrite("SPEDALTH.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUX', .F., .T.)
	
	//Cria Temporario H010
	CriaTRBH("H010",@cAliBLH)
	
	
	/*Leiaute do arquivo temporario
	FILIAL -> Filial
	REG -> "H010"
	COD_ITEM -> 02 COD_ITEM Código do item (campo 02 do Registro 0200)
	UNID -> 03 UNID Unidade do item
	QTD -> 04 QTD Quantidade do item
	VL_UNIT -> 05 VL_UNIT Valor unitário do item
	VL_ITEM -> 06 VL_ITEM Valor do item
	IND_PROP -> 07 IND_PROP Indicador de propriedade/posse do item:
	0 - Item de propriedade do informante e em seu poder;
		1 - Item de propriedade do informante em posse de terceiros
	2 - Item de propriedade de terceiros em posse do informante
	COD_PART -> COD_PART Código do participante (campo 02 do Registro 0150):
	- proprietário/possuidor que não seja o informante do arquivo
	
	COD_CTA -> 10 COD_CTA Código da conta analítica contábil debitada/creditada
	VL_ITEM_IR -> 11 VL_ITEM_IR Valor do item para efeitos do Imposto de Renda.
	
	ALQ_PICM -> Percentual do ICMS do produto no estado
	COD_ORIG -> Origem do produto
	CL_CLASS -> Classificação do produto
	*/
	
	//Alimenta arquivo temporario
	AUX->(DbGoTop())
	While .NOT. AUX->(Eof())
		
		// //0 - Item de propriedade do informante e em seu poder;
		RecLock(cAliBLH,.T.)
		
		(cAliBLH)->FILIAL := AUX->FILIAL
		(cAliBLH)->REG := "H010"
		(cAliBLH)->COD_ITEM := AUX->PRODUTO
		(cAliBLH)->UNID := AUX->UM
		(cAliBLH)->QTD := AUX->QTD_ARM
		(cAliBLH)->VL_UNIT := AUX->VAL_ARM
		(cAliBLH)->VL_ITEM := AUX->TOT_ARM
		
		//0 - Item de propriedade do informante e em seu poder;
			//1 - Item de propriedade do informante em posse de terceiros
		//2 - Item de propriedade de terceiros em posse do informante
		(cAliBLH)->IND_PROP := AUX->SITUACAO
		If AUX->TPCF = "C"
			//Item de propriedade do informante em posse de terceiros
			(cAliBLH)->COD_PART := "SA1" + AUX->CLIFOR + AUX->LOJA
		ElseIf AUX->TPCF = "F"
			//Item de propriedade de terceiros em posse do informante
			(cAliBLH)->COD_PART := "SA2" + AUX->CLIFOR + AUX->LOJA
		EndIf
		
		//Dados do produto
		(cAliBLH)->COD_CTA := AUX->CONTA
		(cAliBLH)->VL_ITEM_IR := 0
		
		(cAliBLH)->ALQ_PICM := 0
		(cAliBLH)->COD_ORIG :="0"
		(cAliBLH)->CL_CLASS :="10"
		
		(cAliBLH)->(MsUnLock())
		
		AUX->(DbSkip())
		
	End
	/*
	//1 - Item de propriedade do informante em posse de terceiros
	RecLock(cAliBLH,.T.)
	
	(cAliBLH)->FILIAL := "01"
	(cAliBLH)->REG := "H010"
	(cAliBLH)->COD_ITEM := "617000038"
	(cAliBLH)->UNID := "UN"
	(cAliBLH)->QTD := 10
	(cAliBLH)->VL_UNIT := 100
	(cAliBLH)->VL_ITEM := 1000
	
	//0 - Item de propriedade do informante e em seu poder;
		//1 - Item de propriedade do informante em posse de terceiros
	//2 - Item de propriedade de terceiros em posse do informante
	(cAliBLH)->IND_PROP := '1'
	
	//Tratamento para poder de terceiros
	cCliefor := PadR(Alltrim("001"),nTamCli)
	cLoja := PadR(Alltrim("01"),nTamLoj)
	(cAliBLH)->COD_PART := "SA1"+cCliefor+cLoja
	
	
	//Dados do produto
	(cAliBLH)->COD_CTA := "1104010003"
	(cAliBLH)->VL_ITEM_IR := 1000
	
	(cAliBLH)->ALQ_PICM := 18
	(cAliBLH)->COD_ORIG :="0"
	(cAliBLH)->CL_CLASS :="00"
	
	(cAliBLH)->(MsUnLock())
	
	
	//2 - Item de propriedade de terceiros em posse do informante
	RecLock(cAliBLH,.T.)
	
	(cAliBLH)->FILIAL := "01"
	(cAliBLH)->REG := "H010"
	(cAliBLH)->COD_ITEM := "617020017"
	(cAliBLH)->UNID := "G"
	(cAliBLH)->QTD := 10
	(cAliBLH)->VL_UNIT := 200
	(cAliBLH)->VL_ITEM := 2000
	
	//0 - Item de propriedade do informante e em seu poder;
		//1 - Item de propriedade do informante em posse de terceiros
	//2 - Item de propriedade de terceiros em posse do informante
	(cAliBLH)->IND_PROP := '2'
	
	//Tratamento para poder de terceiros
	cCliefor := PadR(Alltrim("001"),nTamCli)
	cLoja := PadR(Alltrim("02"),nTamLoj)
	(cAliBLH)->COD_PART := "SA2"+cCliefor+cLoja
	
	
	//Dados do produto
	(cAliBLH)->COD_CTA := "1104010003"
	(cAliBLH)->VL_ITEM_IR := 2000
	
	(cAliBLH)->ALQ_PICM := 18
	(cAliBLH)->COD_ORIG :="0"
	(cAliBLH)->CL_CLASS :="00"
	
	(cAliBLH)->(MsUnLock())
	*/
	
Return cAliBLH// Retorna Alias do arquivo


//------------------------------Criar temporario------------------------
Static Function CriaTRBH(cBloco,cAliasTRB)
	
	Local nX
	Local aIndice := {}
	Local aLayout := {}
	Local cDirSPDK := GetSrvProfString("Startpath","")
	
	Default cAliasTRB := ""
	Default cBloco := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicoes: [1]Campos / [2]Indices ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aLayout := BlocH010(cBloco)
	
	If !ExistDir(cDirSPDK)
		MakeDir(cDirSPDK)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao do Arquivo de Trabalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cBloco)
		cAliasTRB := UPPER(cBloco)+"_"+CriaTrab(,.F.)
		DbCreate(cDirSPDK+cAliasTRB,aLayout[1],__LocalDriver)
		dbUseArea(.T.,__LocalDriver,cDirSPDK+cAliasTRB,cAliasTRB,.T.)
		DbSelectArea(cAliasTRB)
		For nX := 1 to Len(aLayout[2])
			Aadd(aIndice,"k_"+CriaTrab(Nil,.F.))
		Next nX
		For nX := 1 to Len(aLayout[2])
			INDEX ON &(aLayout[2][nX]) TO (aIndice[nX] + OrdBagExt())
		Next nX
		dbClearIndex()
		For nX := 1 to Len(aLayout[2])
			dbSetIndex(aIndice[nX] + OrdBagExt())
		Next nX
		DbSetOrder(1)
	EndIf
	
Return aIndice


//-------------------Leiaute SPED FISCAL--------------------------------------------------------------


Static Function BlocH010(cBloco)
	
	Local aCampos := {}
	Local aIndices := {}
	Local nTamFil := TamSX3("D1_FILIAL" )[1]
	Local nTamCod := TamSX3("B1_COD" )[1]
	Local nTamUNID := TamSX3("B1_UM" )[1]
	Local nTamCC := TamSX3("B1_CONTA" )[1]
	Local aTamPic := TamSX3("B1_PICM" )
	Local nTamOri := TamSX3("B1_ORIGEM" )[1]
	Local nTamClF := TamSX3("B1_CLASFIS")[1]
	Local nTamReg := 4
	Local aTamQtd := {16,3}
	Local aTamVlr := {16,2}
	Local aTmVlUn := {16,6}
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao do Arquivo de Trabalho - BLOCO H010 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {}
	AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0 })
	AADD(aCampos,{"REG" ,"C",nTamReg ,0 })
	AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0 })
	AADD(aCampos,{"UNID" ,"C",nTamUNID ,0 })
	AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] })
	AADD(aCampos,{"VL_UNIT" ,"N",aTmVlUn[1],aTmVlUn[2] })
	AADD(aCampos,{"VL_ITEM" ,"N",aTamVlr[1],aTamVlr[2] })
	AADD(aCampos,{"IND_PROP" ,"C",1 ,0 })
	AADD(aCampos,{"COD_PART" ,"C",60 ,0 })
	AADD(aCampos,{"COD_CTA" ,"C",nTamCC ,0 })
	AADD(aCampos,{"VL_ITEM_IR" ,"N",aTamVlr[1],aTamVlr[2] })
	AADD(aCampos,{"ALQ_PICM" ,"N",aTamPic[1],aTamPic[2] })
	AADD(aCampos,{"COD_ORIG" ,"C",nTamOri })
	AADD(aCampos,{"CL_CLASS" ,"C",nTamClF })
	
	// Indices
	AADD(aIndices,"FILIAL+COD_ITEM+IND_PROP+COD_PART")
	
Return {aCampos,aIndices}
