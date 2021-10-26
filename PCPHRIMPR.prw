#INCLUDE "protheus.ch"
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPHRIMPR º Autor ³ Carlos Torres      º Data ³  25/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rel. Valores de horas improdutivas                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPHRIMPR()
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local oObj

	Private cCadastro := "Demonstrativos de horas improdutivas"
	Private cString := ""
	Private cAliasHRI
	Private cAliasQTC
	Private cAliasIDC

	AjustaSx1( "PCPHRIMPR" )

	If Pergunte("PCPHRIMPR",.T.)
		oObj := MsNewProcess():New({|lEnd| U_TFPCPHRIMPR(oObj, @lEnd)}, "Gera demonstrativos de horas improdutivas", "", .T.)
		oObj :Activate()
	EndIf

Return


/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar o período 
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}
	Local i, j

	cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
	AADD(aRegs, {cPerg, "01","Mes/Ano do relatorio?	","","","mv_ch1","C", 07,00,00,"G","NaoVazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","@R XX/XXXX",""})
	aAdd(aRegs, {cPerg, "02","Recursos?					",'','','mv_ch2','C', 06,00,00,'G','          ','mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','SH1','','',''})
	Aadd(aRegs, {cPerg, "03","Periodo De   ? 			","","","mv_ch3","D", 08,00,00,"G",""			,"mv_par03",""	,"","","","","","","","","","","","","","","","","","","","","","","","","S"	,"",""	})
	Aadd(aRegs, {cPerg, "04","Periodo Ate  ? 			","","","mv_ch4","D", 08,00,00,"G",""			,"mv_par04",""	,"","","","","","","","","","","","","","","","","","","","","","","","","S"	,"",""	})

	SX1->(DbSetOrder(1))
	For i := 1 To Len(aRegs)
		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					SX1->(FieldPut(j, aRegs[i,j]))
				Endif
			Next
			SX1->(MsUnlock())

			aHelpPor := {}
			aHelpSpa := {}
			aHelpEng := {}
			If i == 1
				aAdd(aHelpPor, "Digite MES e ANO do relatorio")
			EndIf
			PutSX1Help("P." + cPerg + StrZero(i,2) + ".", aHelpPor, aHelpEng, aHelpSpa, .T.)
		Endif
	Next
	RestArea(aArea)

Return()


/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar o período 
--------------------------------------------------------------------------------------------------------------
*/
User Function TFPCPHRIMPR(oObj,lEnd)
	Local cArq		:= ""
	Local cScript	:= ""
	Local _nX		:= 0
	Local nArq		:= Nil
	Local aStruSQL	:= {}
	Local nContBg	:= 1
	Local _nY		:= 0
	Local _nZ		:= 0
	Local cRecurso	:= ""
	Local nTotalCl	:= 0
	Local _nRec	:= 0
	Local nCtaCells	:= 0
	Local nElementos	:= 0
	Local cPasta	:= "C:\EXCEL\"
	Local x := 0
	Local y := 0

	MakeDir(Trim(cPasta))

	cArq := Alltrim(cPasta) + "HORAS_IMPRODUTIVAS_" + RIGHT(ALLTRIM(MV_PAR01),4) + "_" + LEFT(ALLTRIM(MV_PAR01),2) + ".HTML"

	FERASE( cArq )

	if file(cArq) .and. ferase(cArq) == -1
		msgstop("Não foi possível abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif

	nArq   := fCreate(cArq,0)

	If nArq = -1
		MsgAlert("O Arquivo não foi criado, informe o erro ao TI:" + STR(FERROR()))
		return(.F.)
	EndIf

	IF .NOT.( APOLECLIENT("MSEXCEL") )
		ConOut("Aplicativo MS Office Excel não está instalado!")
		Return
	ENDIF
	If .NOT. TCSPExist("SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS")
		ConOut(PROCNAME() + "--> PROCEDURE SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS não está instalada!")
		Return
	EndIf

	cRecurso := MV_PAR02

	_nRec := SH1->(LastRec())
	oObj:SetRegua1(_nRec)

	SH1->(DbGoTop())
	While !SH1->(Eof())
		If (!EMPTY(MV_PAR02) .AND. ALLTRIM(cRecurso) = ALLTRIM(SH1->H1_CODIGO)) .OR. EMPTY(MV_PAR02)

			nElementos ++
			oObj:IncRegua1("Processando item " + Alltrim(Str(nElementos)) + " de " + Alltrim(Str(_nRec)) + " encontrados.")

			cRecurso := ALLTRIM(SH1->H1_CODIGO)

			CSQL := "EXEC SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS "
			CSQL += "'" + RIGHT(ALLTRIM(MV_PAR01),4) + LEFT(ALLTRIM(MV_PAR01),2) + "','" + ALLTRIM(cRecurso) + "','','" + DTOS(MV_PAR03) + "','" + DTOS(MV_PAR04) + "'"

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,CSQL),(cAliasHRI := GetNextAlias()), .F., .T.)

			_nRec2 := 0
			nTotalCl := 0
			(cAliasHRI)->(DbGoTop())
			While !(cAliasHRI)->(Eof())
				_nRec2 += 1
				nTotalCl += (cAliasHRI)->LTOTAL
				(cAliasHRI)->(DbSkip())
			End

			If nTotalCl > 0
				nCtaCells := 0
				oObj:SetRegua2(_nRec2)

				cQuery := " SELECT CBH_RECUR,CELULA FROM TEMP_CT_ID_CELULA"
				DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasIDC := GetNextAlias()),.F.,.T.)

				cQuery := " SELECT QTD_CELULAS,QTD_DIAS FROM TEMP_CT_PCP_HORAS"
				DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasQTC := GetNextAlias()),.F.,.T.)

				DBSELECTAREA( (cAliasHRI) )

				cHtmlOk := fHtmlTitulo("")
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				cHtmlOk := fHtmlCabec("")
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				DbSelectArea(cAliasHRI)
				(cAliasHRI)->(DbGoTop())

				aStruSQL	:= {}

				//ProcRegua(nCtaCells)
				(cAliasHRI)->(DbGoTop())
				/* carga da matriz com dados da celulas */
				Do While (cAliasHRI)->(!Eof())

					nCtaCells++
					oObj:IncRegua2("Processando item "+Alltrim(Str(nCtaCells))+ " de " + Alltrim(Str(_nRec2)) + " itens.")

					aCmpsSQL := {}

					FOR _nX := 2 TO FCOUNT()

						IF _nX = 1
							AADD(aCmpsSQL,&( (cAliasHRI)->(FIELDNAME(_nX))))
						Else
							AADD(aCmpsSQL,CvalToChar(&( (cAliasHRI)->(FIELDNAME(_nX)))))
						EndIf

					NEXT _nX

					aAdd( aStruSQL , aCmpsSQL  )

					(cAliasHRI)->(DbSkip())
				Enddo

				cHtmlOk := CRLF+' <table> '
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))
				/* grava no arquivo HTML os dados das celulas */

				For y:=1 To Len(aStruSQL) - 3

					IncProc("Gerando arquivo Excel. Aguarde...")

					nContBg ++
					If nContBg%2 == 0
						cBgClr := "#FFFFFF"
					Else
						cBgClr := "#B5CDE5"
					EndIf
					cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
					cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[y][1] +'&nbsp;</td> '
					For x:=2 To FCOUNT() - 1
						cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[y][x] +'</td> '
					Next x

					cHtmlOk += CRLF+' </tr> '

					//Carrega HTML
					FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				Next y
				cHtmlOk := CRLF+' </table> '
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				cHtmlOk := CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF"> '
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))
				/* grava no arquivo HTML os dados das celulas */

				For _ny:=y  To Len(aStruSQL)

					IncProc("Gerando arquivo Excel. Aguarde...")

					nContBg ++
					If nContBg%2 == 0
						cBgClr := "#FFFFFF"
					Else
						cBgClr := "#B5CDE5"
					EndIf
					cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
					cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[_ny][1] +'&nbsp;</td> '
					For x:=2 To FCOUNT() - 1
						cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[_ny][x] +'</td> '
					Next x

					cHtmlOk += CRLF+' </tr> '

					//Carrega HTML
					FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				Next _ny
				cHtmlOk := CRLF+' </table> '
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

				(cAliasQTC)->(dbCloseArea())
				(cAliasIDC)->(dbCloseArea())

			EndIf

			(cAliasHRI)->(dbCloseArea())

		EndIf
		SH1->(DbSkip())
	End

	/* impressão da visão consolidada */
	If Empty( MV_PAR02 )

		CSQL := "EXEC SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS "
		CSQL += "'" + RIGHT(ALLTRIM(MV_PAR01),4) + LEFT(ALLTRIM(MV_PAR01),2) + "','TODOS','','" + DTOS(MV_PAR03) + "','" + DTOS(MV_PAR04) + "'"

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,CSQL),(cAliasHRI := GetNextAlias()), .F., .T.)

		_nRec2 := 0
		nTotalCl := 0
		(cAliasHRI)->(DbGoTop())
		While !(cAliasHRI)->(Eof())
			_nRec2 += 1
			nTotalCl += (cAliasHRI)->LTOTAL
			(cAliasHRI)->(DbSkip())
		End

		If nTotalCl > 0
			nCtaCells := 0
			oObj:SetRegua2(_nRec2)

			cQuery := " SELECT CBH_RECUR,CELULA FROM TEMP_CT_ID_CELULA"
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasIDC := GetNextAlias()),.F.,.T.)

			cQuery := " SELECT QTD_CELULAS,QTD_DIAS FROM TEMP_CT_PCP_HORAS"
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasQTC := GetNextAlias()),.F.,.T.)

			DBSELECTAREA( (cAliasHRI) )

			cHtmlOk := fHtmlTitulo("C")
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			cHtmlOk := fHtmlCabec("C")
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			DbSelectArea(cAliasHRI)
			(cAliasHRI)->(DbGoTop())

			aStruSQL	:= {}

			//ProcRegua(nCtaCells)
			(cAliasHRI)->(DbGoTop())
			/* carga da matriz com dados da celulas */
			Do While (cAliasHRI)->(!Eof())

				nCtaCells++
				oObj:IncRegua2("Processando item "+Alltrim(Str(nCtaCells))+ " de " + Alltrim(Str(_nRec2)) + " itens.")

				aCmpsSQL := {}

				FOR _nX := 2 TO FCOUNT()

					IF _nX = 1
						AADD(aCmpsSQL,&( (cAliasHRI)->(FIELDNAME(_nX))))
					Else
						AADD(aCmpsSQL,CvalToChar(&( (cAliasHRI)->(FIELDNAME(_nX)))))
					EndIf

				NEXT _nX

				aAdd( aStruSQL , aCmpsSQL  )

				(cAliasHRI)->(DbSkip())
			Enddo

			cHtmlOk := CRLF+' <table> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
			/* grava no arquivo HTML os dados das celulas */

			For y:=1 To Len(aStruSQL) - 3

				IncProc("Gerando arquivo Excel. Aguarde...")

				nContBg ++
				If nContBg%2 == 0
					cBgClr := "#FFFFFF"
				Else
					cBgClr := "#B5CDE5"
				EndIf
				cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
				cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[y][1] +'&nbsp;</td> '
				For x:=2 To FCOUNT() - 1
					cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[y][x] +'</td> '
				Next x

				cHtmlOk += CRLF+' </tr> '

				//Carrega HTML
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			Next y
			cHtmlOk := CRLF+' </table> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			cHtmlOk := CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF"> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
			/* grava no arquivo HTML os dados das celulas */

			For _ny:=y  To Len(aStruSQL)

				IncProc("Gerando arquivo Excel. Aguarde...")

				nContBg ++
				If nContBg%2 == 0
					cBgClr := "#FFFFFF"
				Else
					cBgClr := "#B5CDE5"
				EndIf
				cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
				cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[_ny][1] +'&nbsp;</td> '
				For x:=2 To FCOUNT() - 1
					cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[_ny][x] +'</td> '
				Next x

				cHtmlOk += CRLF+' </tr> '

				//Carrega HTML
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			Next _ny
			cHtmlOk := CRLF+' </table> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))

			(cAliasQTC)->(dbCloseArea())
			(cAliasIDC)->(dbCloseArea())

		EndIf

		(cAliasHRI)->(dbCloseArea())

	EndIf

	cHtmlOk := fHtmlRodap()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	fClose(nArq)

	If ApOleClient("MsExcel")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArq)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		ShellExecute("open",cArq,"","",1)
	EndIf

RETURN NIL

Static Function fHtmlTitulo(cVisao)

	Local cHtml := ""

	cHtml += CRLF+' <html> '
	cHtml += CRLF+' <head> '
	cHtml += CRLF+' <title>&nbsp;</title> '
	cHtml += CRLF+' </head> '
	cHtml += CRLF+' <body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" link="#000000" vlink="#000000" alink="#000000"> '
	cHtml += CRLF+' <!-- CABEÇALHO --> '
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtml += CRLF+' 	<tr><td>&nbsp;</td></tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:20px"> '
	//cHtml += CRLF+' 		<td height="90" width="25%" colspan="5" rowspan="1" align="center" valign="middle">&nbsp;</td> '
	//cHtml += CRLF+' 		<td height="90" width="50%" rowspan="1" align="center" valign="middle"><b>HORAS IMPRODUTIVAS</b></td> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>HORAS IMPRODUTIVAS</b></td> '
	cHtml += CRLF+' 	</tr> '
	If cVisao = "C"
		cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:20px"> '
		cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>CONSOLIDADO</b></td> '
		cHtml += CRLF+' 	</tr> '
	EndIf
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:20px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>PERIODO: ' + TRANSFORM(MV_PAR01,"@R XX/XXXX") + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	If .NOT. EMPTY(MV_PAR03)
		cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
		cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>DE: ' + DTOC(MV_PAR03) + ' ATE ' + DTOC(MV_PAR04) + '</b></td> '
		cHtml += CRLF+' 	</tr> '
	EndIf
	cHtml += CRLF+' </table> '
	cHtml += CRLF+' <!-- UMA LINHA PARA ESPAÇO --> '
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" colspan="8">&nbsp;</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' </table> '

Return(cHtml)

Static Function fHtmlCabec(cVisao)

	Local cHtml   := ""
	Local nLpDias := 0
	Local nLpCelulas := 0

	cHtml += CRLF+' <!-- DETALHAMENTO -->'
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">'

	cHtml += CRLF+' 	<tr valign="middle" style=" color:#FFFFFF; font-family:Tahoma; font-size:16px" bgcolor="#000066">'
	cHtml += CRLF+'		<td colspan="1"><b>&nbsp; </b></td>'
	cHtml += CRLF+'		<td colspan="' + STR((cAliasQTC)->QTD_CELULAS*(cAliasQTC)->QTD_DIAS) + '" align="center"><b>CELULA</b></td>'
	cHtml += CRLF+'	</tr>'

	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:14px" bgcolor="#708090">'
	cHtml += CRLF+' 		<td>&nbsp;Improdutivo&nbsp;</td>'
	If Empty(cVisao)
		(cAliasIDC)->(DbGoTop())
		While !(cAliasIDC)->(Eof())
			cHtml += CRLF+' 		<td colspan="' + STR((cAliasQTC)->QTD_DIAS) + '">&nbsp; ' + (cAliasIDC)->CBH_RECUR + '&nbsp;</td>'
			(cAliasIDC)->(DbSkip())
		End
	Else
		cHtml += CRLF+' 		<td colspan="' + STR((cAliasQTC)->QTD_DIAS) + '">&nbsp; &nbsp;</td>'
	EndIf

	cHtml += CRLF+' 		<td>&nbsp;Total&nbsp;</td>'
	cHtml += CRLF+' 	</tr>'


	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:18px" bgcolor="#708090">'
	cHtml += CRLF+' 		<td align="right" >&nbsp;Dias->&nbsp;</td>'
	For nLpCelulas:= 1 to (cAliasQTC)->QTD_CELULAS
		For nLpDias:= 1 to (cAliasQTC)->QTD_DIAS
			cHtml += CRLF+' 		<td>&nbsp;' + StrZero(nLpDias,2)+ '&nbsp;</td>'
		Next
	Next
	cHtml += CRLF+' 		<td>&nbsp;&nbsp;</td>'
	cHtml += CRLF+' 	</tr>'

	cHtml += CRLF+' </table> '

Return(cHtml)

Static Function fHtmlRodap()

	Local cHtml := ""

	cHtml += CRLF+' </body> '
	cHtml += CRLF+' </html> '

Return(cHtml)