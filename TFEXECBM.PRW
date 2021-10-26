#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'

#DEFINE PL CHR(13) + CHR(10)

/*
-----------------------------------------------------------------------------------------------------
Arquivo...:	TFEXECBM.PRW
Descricao.:	Funcao que gera Planilha Excel (XML) do balanço de massa com informacoes do Estoque 
Autor.....:	Carlos Torres  													
Data......:	26/03/2014
Observaçao: Rotina será executada pelo SCHEDULE do PROTHEUS
-----------------------------------------------------------------------------------------------------
*/

USER FUNCTION TFEXECBM()

	Local cScript	:="EXEC [SP_BALANCO_DE_MASSA_PASSO_1]" /*cria tabelas de balanço de massa Analitica/Sintetica 3 minutos */
	Local lOpenOk	:= .F.
	Local cQuery
	Local cDthIni	:= " em " + Dtoc(date()) + " as " + Substr(Time(),1,5)
	Local cHoraIni:= Time()
	Local lForced := .F.
	Local nConta	:= 0
	Local cDthFim	:= ""


	Private cPasta

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SA1"

	ConOut('-->TFEXECBM [Iniciado processo Balanco de Massa] ' + cDthIni )
	ConOut('--*TFEXECBM [Executa procedure SP_BALANCO_DE_MASSA_PASSO_1]')
	nRet := TCSqlExec(cScript)

	ConOut('--*TFEXECBM [Aguardando a existencia da tabela TEMP_SEMAFARO_BM]')
	While !lOpenOk
		If TCCanOpen("TEMP_SEMAFARO_BM")
			lOpenOk:= .T.
		EndIf
		nConta++
		If nConta>10000
			nConta:=0
			If Val(Substr(ElapTime(cHoraIni,Time()),1,2)) > 3
				ConOut('--*TFEXECBM [Forçado o fim de LOOP da existencia da tabela TEMP_SEMAFARO_BM]')
				lOpenOk:= .T.
				lForced:= .T.
			EndIf
		EndIf
	End

	If lOpenOk .and. .NOT. lForced
		cQuery := "SELECT RTRIM(LTRIM(BM_PASTABM)) AS BM_PASTABM FROM TEMP_SEMAFARO_BM "
		If Select("TMPSEM") > 0
			TMPSEM->(DbCloseArea())
		Endif
		TcQuery cQuery NEW ALIAS ("TMPSEM")
		cPasta := Alltrim(TMPSEM->BM_PASTABM)
		TMPSEM->(DbCloseArea())

		ConOut('--*TFEXECBM [Iniciado processo gerador de planilhas]')
		U_TFEXECCD(cPasta)

		ConOut('--*TFEXECBM [Iniciado processo DROP de tabelas temporarias]')
		cScript :="EXEC [SP_BALANCO_DE_MASSA_DROP_TEMP]"
		nRet := TCSqlExec(cScript)
	EndIf

	cDthFim := " em " + Dtoc(date()) + " as " + Substr(Time(),1,5)
	cDthFim += " Tempo decorrido: "+ElapTime(cHoraIni,Time())

	ConOut('<--TFEXECBM [Fim do processamento] '+cDthFim)

	RpcClearEnv()
Return

USER FUNCTION A_TFEXECBM()

	Local cScript	:="EXEC [SP_BALANCO_DE_MASSA_PASSO_1]" /*cria tabelas de balanço de massa Analitica/Sintetica 3 minutos */
	Local lOpenOk	:= .F.
	Local cQuery
	Local cDthIni	:= " em " + Dtoc(date()) + " as " + Substr(Time(),1,5)
	Local cHoraIni:= Time()
	Local lForced := .F.
	Local nConta	:= 0
	Local cDthFim	:= ""


	Private cPasta

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SA1"

	ConOut('-->TFEXECBM [Iniciado processo Balanco de Massa] ' + cDthIni )
	ConOut('--*TFEXECBM [Executa procedure SP_BALANCO_DE_MASSA_PASSO_1]')
	nRet := TCSqlExec(cScript)

	ConOut('--*TFEXECBM [Aguardando a existencia da tabela TEMP_SEMAFARO_BM]')
	While !lOpenOk
		If TCCanOpen("TEMP_SEMAFARO_BM")
			lOpenOk:= .T.
		EndIf
		nConta++
		If nConta>10000
			nConta:=0
			If Val(Substr(ElapTime(cHoraIni,Time()),1,2)) > 3
				ConOut('--*TFEXECBM [Forçado o fim de LOOP da existencia da tabela TEMP_SEMAFARO_BM]')
				lOpenOk:= .T.
				lForced:= .T.
			EndIf
		EndIf
	End

	If lOpenOk .and. .NOT. lForced
		cQuery := "SELECT RTRIM(LTRIM(BM_PASTABM)) AS BM_PASTABM FROM TEMP_SEMAFARO_BM "
		If Select("TMPSEM") > 0
			TMPSEM->(DbCloseArea())
		Endif
		TcQuery cQuery NEW ALIAS ("TMPSEM")
		cPasta := Alltrim(TMPSEM->BM_PASTABM)
		TMPSEM->(DbCloseArea())

		ConOut('--*TFEXECBM [Iniciado processo gerador de planilhas]')
		U_TFEXECTAIFF()

		ConOut('--*TFEXECBM [Iniciado processo DROP de tabelas temporarias]')
		cScript :="EXEC [SP_BALANCO_DE_MASSA_DROP_TEMP]"
		nRet := TCSqlExec(cScript)
	EndIf

	cDthFim := " em " + Dtoc(date()) + " as " + Substr(Time(),1,5)
	cDthFim += " Tempo decorrido: "+ElapTime(cHoraIni,Time())

	ConOut('<--TFEXECBM [Fim do processamento] '+cDthFim)

	RpcClearEnv()
Return

/*
-----------------------------------------------------------------------------------------------------
Criar planilha da TAIFF
-----------------------------------------------------------------------------------------------------
*/
USER FUNCTION TFEXECTAIFF()

	LOCAL 		CSQL		:= ""
	LOCAL		NX			:= 0
	LOCAL 		AITENS		:= {}
	LOCAL 		AITTT		:= {}
	LOCAL 		ASTRUCT	:= {}
	LOCAL 		OEXCEL 	:= FWMSEXCEL():NEW()
	LOCAL 		CTITSHEET	:= "Analitico"
	LOCAL 		CTITTABLE	:= "Analitico"
	Local cArq		:= ""
	//Local cScript	:= ""
	Local cTime	:= Time()

	While At(":",cTime) != 0
		cTime := Stuff( cTime , At(":",cTime),1,"" )
	End

	cArq := cPasta+"Movimentos_dos_Armazens_para_BM_" + Dtos(Date()) + "_" + cTime + ".XLS"

	IF .NOT.( APOLECLIENT("MSEXCEL") )
		ConOut("Aplicativo MS Office Excel não está instalado!")
		//BREAK
	ENDIF

	OEXCEL:ADDWORKSHEET(CTITSHEET)
	OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
	OEXCEL:SETTITLESIZEFONT(14)
	OEXCEL:SETTITLEBOLD(.T.)
	OEXCEL:SETTITLEFRCOLOR("#000000")
	OEXCEL:SETTITLEBGCOLOR("#778899")
	OEXCEL:SETLINESIZEFONT(11)
	OEXCEL:SET2LINESIZEFONT(11)

	IF SELECT("TMPBM") > 0

		DBSELECTAREA("TMPBM")
		DBCLOSEAREA()

	ENDIF

	CSQL := "EXEC SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_PLANILHA "
	TCQUERY CSQL NEW ALIAS "TMPBM"
	DBSELECTAREA("TMPBM")

	ASTRUCT := DBSTRUCT()
	ConOut('--*TFEXECBM [No loop dos campos]')

	FOR NX := 1 TO FCOUNT()

		DO CASE
		CASE ASTRUCT[NX,02] = "C"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,1)
		CASE ASTRUCT[NX,02] = "N"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,2)
		CASE ASTRUCT[NX,02] = "D"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,4)
		ENDCASE

	NEXT NX

	ConOut('--*TFEXECBM [No loop dos dados]')
	WHILE TMPBM->(!EOF())

		AITENS := {}
		AITTT	:= {}

		FOR NX := 1 TO FCOUNT()

			AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))

		NEXT NX

		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		TMPBM->(DBSKIP())

	ENDDO

	ConOut('--*TFEXECBM [Gravando arquivo] ' + cArq)

	OEXCEL:ACTIVATE()
	OEXCEL:GETXMLFILE( cArq )
	OEXCEL:DEACTIVATE()



RETURN

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar o período 
--------------------------------------------------------------------------------------------------------------
*/
User Function TFEXECCD(cPasta)
	Local cArq		:= ""
	//Local cScript	:= ""
	Local _nX		:= 0
	Local nArq		:= Nil
	Local aStruSQL	:= {}
	Local nContBg	:= 1
	Local cTime		:= Time()
	//Local _nY		:= 0
	//Local _nZ		:= 0
	//Local cRecurso	:= ""
	//Local nTotalCl	:= 0
	//Local _nRec	:= 0
	//Local nCtaCells	:= 0
	//Local nElementos	:= 0
	Local x 		:= 0
	Local y 		:= 0
	//Local cPasta	:= "" // "C:\TEMP\"

	Private cAliasHRI

	While At(":",cTime) != 0
		cTime := Stuff( cTime , At(":",cTime),1,"" )
	End
	// MakeDir(Trim(cPasta))

	cArq := Alltrim(cPasta) + "POSICAO_DE_ESTOQUE_" + Dtos(Date()) + "_" + cTime + ".HTML"

	FERASE( cArq )

	if file(cArq) .and. ferase(cArq) == -1
		CONOUT("TFEXECBM " + ALLTRIM(STR(PROCLINE())) + " - Não foi possível abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif

	nArq   := fCreate(cArq,0)

	If nArq = -1
		CONOUT("TFEXECBM " + ALLTRIM(STR(PROCLINE())) + " - O Arquivo não foi criado, informe o erro ao TI:" + STR(FERROR()))
		return(.F.)
	EndIf

	If .NOT. TCSPExist("SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM")
		ConOut("TFEXECBM " + ALLTRIM(STR(PROCLINE())) + " - PROCEDURE SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM não está instalada!")
		Return
	EndIf

	CSQL := "EXEC SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,CSQL),(cAliasHRI := GetNextAlias()), .F., .T.)

	DBSELECTAREA( (cAliasHRI) )

	cHtmlOk := fHtmlTitulo("C")
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	cHtmlOk := fHtmlCabec("C")
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	(cAliasHRI)->(DbGoTop())

	aStruSQL	:= {}

	CONOUT("TFEXECBM " + ALLTRIM(STR(PROCLINE())) + " - Gerando arquivo fase I. Aguarde...")
	/* carga da matriz com dados da celulas */
	Do While (cAliasHRI)->(!Eof())

		aCmpsSQL := {}

		FOR _nX := 1 TO FCOUNT()

			IF _nX = 1 .OR. _nX = 6
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

	CONOUT("TFEXECBM " + ALLTRIM(STR(PROCLINE())) + " - Gerando arquivo fase II. Aguarde...")
	For y:=1 To Len(aStruSQL) - 3

		nContBg ++
		If nContBg%2 == 0
			cBgClr := "#FFFFFF"
		Else
			cBgClr := "#B5CDE5"
		EndIf
		cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:18px"> '
		cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[y][1] +'&nbsp;</td> '
		For x:=2 To FCOUNT()
			If x=6
				cHtmlOk += CRLF+' 	<td align="left">' + aStruSQL[y][x] +'</td> '
			Else
				cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[y][x] +'</td> '
			EndIf
		Next x

		cHtmlOk += CRLF+' 	<td align="right">=+B'+ alltrim(str(6+y)) +'+D' + alltrim(str(6+y)) + '</td> '
		cHtmlOk += CRLF+' 	<td align="right">0</td> '
		cHtmlOk += CRLF+' 	<td align="right">0</td> '
		cHtmlOk += CRLF+' 	<td align="right">=+(J'+ alltrim(str(6+y)) +'*H' + alltrim(str(6+y)) + ')+K' + alltrim(str(6+y)) +'</td> '
		cHtmlOk += CRLF+' 	<td align="right">=+L'+ alltrim(str(6+y)) +'-I'+ alltrim(str(6+y)) +'</td> '
		cHtmlOk += CRLF+' 	<td align="left"></td> '


		cHtmlOk += CRLF+' </tr> '

		//Carrega HTML
		FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	Next y
	cHtmlOk := CRLF+' </table> '
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	cHtmlOk := CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF"> '
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))
	/* grava no arquivo HTML os dados das celulas */

	(cAliasHRI)->(dbCloseArea())

	cHtmlOk := fHtmlRodap()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	fClose(nArq)

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
	cHtml += CRLF+' 		<td rowspan="1" td colspan="14" align="center" valign="middle"><b>POSICAO DE ESTOQUE</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:20px"> '
	cHtml += CRLF+' 		<td rowspan="1" td colspan="14" align="center" valign="middle"><b>' + 'TAIFFPROART - EXTREMA' + '</b></td> '
	cHtml += CRLF+' 	</tr> '
	//cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:10px"> '
	//cHtml += CRLF+' 		<td rowspan="1" align="center" valign="middle"><b>' + ' EXTREMA ' + '</b></td> '
	//cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' </table> '
	cHtml += CRLF+' <!-- UMA LINHA PARA ESPAÇO --> '
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" colspan="14">&nbsp;</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' </table> '

Return(cHtml)

Static Function fHtmlCabec(cVisao)

	Local cHtml   := ""

	cHtml += CRLF+' <!-- DETALHAMENTO -->'
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">'

	cHtml += CRLF+' 	<tr valign="middle" style=" color:#FFFFFF; font-family:Tahoma; font-size:16px" bgcolor="#000066">'
	cHtml += CRLF+'		<td colspan="1"><b>&nbsp; </b></td>'
	cHtml += CRLF+'		<td colspan="' + '13' + '" align="center"><b>CONTAGEM DO ARMAZEM 21</b></td>'
	cHtml += CRLF+'	</tr>'

//	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:14px" bgcolor="#708090">'
//	cHtml += CRLF+' 		<td>&nbsp;_VER_USO_II_&nbsp;</td>'

//	cHtml += CRLF+' 		<td>&nbsp;_VER_USO_III_&nbsp;</td>'
//	cHtml += CRLF+' 	</tr>'


	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Calibri; font-size:18px" bgcolor="#708090">'
	cHtml += CRLF+' 		<td align="left" >&nbsp;PRODUTO&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'SALDO_ATUAL' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'ARMAZEM' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'OS_ABERTA_POR_NF' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'OS_ABERTA_POR_PEDID' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td align="left" >&nbsp;' + 'DESCRICAO' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'DATA_HORA' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'EAN_14' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'SALDO_FISICO' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'PALLET' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'UNITARIO' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'TOTAL FISICO' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'DIVERGENCIAS' + '&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;' + 'COMENTARIO' + '&nbsp;</td>'
	cHtml += CRLF+' 	</tr>'

	cHtml += CRLF+' </table> '

Return(cHtml)

Static Function fHtmlRodap()

	Local cHtml := ""

	cHtml += CRLF+' </body> '
	cHtml += CRLF+' </html> '

Return(cHtml)
