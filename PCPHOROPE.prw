#Include 'Protheus.ch'
#INCLUDE "Topconn.ch"
#DEFINE ENTER chr(13)+chr(10)
/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPHOROPE º Autor ³ Carlos Torres      º Data ³  10/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rel. detalhe de apontamento 		                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCPHOROPE()
Local aParamBox	:= {}
Local aRet			:= {}
Local oObj	 

Private cCadastro := "Divergencias de apontamento de horas"
Private cString := ""
Private cAliasHRI
Private cAliasQTC
Private cAliasIDC
Private cTFlider := __CUSERID

AjustaSx1( "PCPHOROPE" ) 

If Pergunte("PCPHOROPE",.T.)
	If U_TFvalidaLider( cTFlider )
		oObj := MsNewProcess():New({|lEnd| U_TFPCPHOROPE(oObj, @lEnd)}, "Gera lista de apontamento de horas", "", .T.)
		oObj :Activate()
	Else
		MsgStop("Usuário com restrição de uso da rotina!")
	EndIf
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
AADD(aRegs, {cPerg, "01","Operador?			","","","mv_ch1","C", 07,00,00,"G",""			,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CB1","","","","",""})
aAdd(aRegs, {cPerg, "02","Recursos?			",'','','mv_ch2','C', 06,00,00,'G',""			,'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','SH1','','',''})
Aadd(aRegs, {cPerg, "03","Periodo De   ? 	","","","mv_ch3","D", 08,00,00,"G","NaoVazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","S"	,"",""	})
Aadd(aRegs, {cPerg, "04","Periodo Ate  ? 	","","","mv_ch4","D", 08,00,00,"G","NaoVazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","S"	,"",""	})

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
User Function TFPCPHOROPE(oObj,lEnd)
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
Local cPasta		:= "C:\EXCEL\"
Local cHrAcumaldo	:= "00:00"
Local nHrAntes		:= 0
Local nProducao	:= 0
Local cCBHOPERAD	:= ""
Local cC2PRODUTO	:= ""
Local cMensAdicional := ""
Local x := 0
Local y := 0

	MakeDir(Trim(cPasta))
	
	cArq := Alltrim(cPasta) + "DETALHE_APONTAMENTO_" + DTOS(dDataBase) + "_" + LEFT(TIME(),2) + SUBSTR(TIME(),4,2) + ".HTML"

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
	If .NOT. TCSPExist("SP_REL_PCP_DETALHE_APONTAMENTO_DE_HORAS_PROTHEUS")
		ConOut(PROCNAME() + "--> PROCEDURE SP_REL_PCP_DETALHE_APONTAMENTO_DE_HORAS_PROTHEUS não está instalada!")
		Return
	EndIf
			
	CSQL := "EXEC SP_REL_PCP_DETALHE_APONTAMENTO_DE_HORAS_PROTHEUS "
	CSQL += "'" + MV_PAR01 + "','" + MV_PAR02 + "','" + DTOS(MV_PAR03) + "','" + DTOS(MV_PAR04) + "','" + cTFlider + "'"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,CSQL),(cAliasHRI := GetNextAlias()), .F., .T.)
			
	DBSELECTAREA( (cAliasHRI) )
	
	_nRec2 := RECCOUNT()
	(cAliasHRI)->(DbGoTop())

	If (cAliasHRI)->(Eof())
		MsgAlert("Não há dados para os parâmetros selecionados!" )
	Else
		
		(cAliasHRI)->(DbGoTop())
		While (cAliasHRI)->(!Eof())
		
			cCBHOPERAD := (cAliasHRI)->ID_OPERADOR 
			cC2PRODUTO	:= (cAliasHRI)->C2_PRODUTO
			
			cHtmlOk := fHtmlTitulo()
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
					
			cHtmlOk := fHtmlCabec("")
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
					
			aStruSQL	:= {}
			cHrAcumaldo:= "00:00"
			nProducao := 0
			
			//ProcRegua(nCtaCells)
			/* carga da matriz com dados da celulas */
			While (cAliasHRI)->(!Eof()) .AND. (cAliasHRI)->ID_OPERADOR = cCBHOPERAD .AND. (cAliasHRI)->C2_PRODUTO = cC2PRODUTO
		
				nCtaCells++
				oObj:IncRegua1("Processando item "+Alltrim(Str(nCtaCells))+ " de " + Alltrim(Str(_nRec2)) + " itens.")
			
				aCmpsSQL := {}
				
				FOR _nX := 1 TO FCOUNT()
					
					IF _nX = 0
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
					
			For y:=1 To Len(aStruSQL)
			
				IncProc("Gerando arquivo Excel. Aguarde...")
			
				nContBg ++
				If nContBg%2 == 0
					cBgClr := "#FFFFFF"
				Else
					cBgClr := "#B5CDE5"
				EndIf
				cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
				cDIF := ""
				cMensAdicional := ""
				If Alltrim(aStruSQL[y][1]) = "PRODUCAO" 
					If nProducao != 0
						cDIF := ElapTime(nHrAntes, aStruSQL[y][2] + ":00")
						nHrAntes := aStruSQL[y][3] + ":00"
						If cDIF > "23:00:00"
							cMensAdicional := "Atenção verifique HORA INICIO "
						EndIf
						If cDIF != "00:00:00" .AND. cDIF < "23:00:00" 
							cHrAcumaldo := somahoras(cHrAcumaldo,Substr(cDIF,1,5))
						Else
							cDIF := "00:00:00"					
						EndIf
					Else
						nHrAntes 	:= aStruSQL[y][3] + ":00"
						cDIF := "00:00:00"
					EndIf
					nProducao++ 
				EndIf
				For x:=1 To FCOUNT() - 9
					If x=1
						cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[y][x] +'</td> '
					Else
						cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[y][x] +'</td> '
					EndIf
				Next x
				cHtmlOk += CRLF+' 	<td align="right">' + CvalToChar(cDIF) +'&nbsp;</td> '
				cHtmlOk += CRLF+' 	<td align="right">' + CvalToChar(cMensAdicional) +'&nbsp;</td> '
				cHtmlOk += CRLF+' </tr> '
		
				//Carrega HTML
				FWrite(nArq,cHtmlOk,Len(cHtmlOk))
		
			Next y
			cHtmlOk := CRLF+' </table> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
			
			
			/* imprime total das horas perdidas */
			cHtmlOk := CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF"> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
		
			nContBg ++
			If nContBg%2 == 0
				cBgClr := "#FFFFFF"
			Else
				cBgClr := "#B5CDE5"
			EndIf
			cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
			cHtmlOk += CRLF+' 	<td align="right"> &nbsp;</td> '
			cHtmlOk += CRLF+' 	<td align="right"> &nbsp;</td> '
			cHtmlOk += CRLF+' 	<td align="right">T o t a l</td> '
			If VALTYPE(cHrAcumaldo)="N"
				cHtmlOk += CRLF+' 	<td align="left">' + CvalToChar(STRZERO(cHrAcumaldo,5,2)) +'&nbsp;</td> '
			Else
				cHtmlOk += CRLF+' 	<td align="right"> &nbsp;</td> '
			EndIf						
			cHtmlOk += CRLF+' 	<td align="right"> &nbsp;</td> '
							
			cHtmlOk += CRLF+' </tr> '
		
			//Carrega HTML
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
		
			cHtmlOk := CRLF+' </table> '
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
					
		End
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
	EndIf
	(cAliasHRI)->(DbCloseArea())
	
RETURN NIL


Static Function fHtmlTitulo()

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
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>DETALHE DO APONTAMENTO</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>OPERADOR: ' + (cAliasHRI)->CB1_NOME + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>PRODUTO: ' + (cAliasHRI)->C2_PRODUTO + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>CELULA: ' + (cAliasHRI)->RECURSO + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>DE: ' + DTOC(MV_PAR03) + ' ATE ' + DTOC(MV_PAR04) + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>SOLICITANTE: ' + ALLTRIM(UsrFullName(__CUSERID)) + '</b></td> '
	cHtml += CRLF+' 	</tr> '
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

	cHtml += CRLF+' <!-- DETALHAMENTO -->'
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">'

	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:18px" bgcolor="#708090">'
	cHtml += CRLF+' 		<td align="LEFT" >&nbsp;APONTAMENTO&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;HORA INI&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;HORA FIM&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;DIF&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;OBSERVACAO&nbsp;</td>'
	cHtml += CRLF+' 	</tr>'

	cHtml += CRLF+' </table> '

	Return(cHtml)

Static Function fHtmlRodap()

	Local cHtml := ""

	cHtml += CRLF+' </body> '
	cHtml += CRLF+' </html> '

	Return(cHtml)
	
/*
--------------------------------------------------------------------------------------------------------------
Função para determinar se filtra pelo lider ou pelo cadastro de Gestão de Rotinas  
--------------------------------------------------------------------------------------------------------------
*/
User Function TFvalidaLider(cIDlider)
Local lReturn := .F.
Local cQuery := ""

cQuery := " SELECT COUNT(*) AS CTA_LIDER "		+ ENTER
cQuery += " FROM " + RetSqlName("CB1") + " CB1 " 			+ ENTER
cQuery += " WHERE CB1.D_E_L_E_T_ <> '*' " 					+ ENTER
cQuery += " AND CB1_FILIAL	= '" + xFilial("CB1") + "'" 	+ ENTER
cQuery += " AND CB1_SUPERV = '" + cIDlider + "'"

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cAlias2 := GetNextAlias()), .F., .T.)

If 	(_cAlias2)->CTA_LIDER = 0
	If .NOT. U_CHECAFUNC(cIDlider,"PCPHOROPE")
		lReturn := .T.
		cTFlider := "" // quando vazio gera resultados incondicionalmente do lider
	EndIf
Else
	lReturn := .T.
Endif
(_cAlias2)->(DbCloseArea())

Return (lReturn)
