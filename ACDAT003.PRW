//#INCLUDE "acdv165.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'
#DEFINE ENTER Chr(13)+Chr(10)

// variaveis usadas para POSICAO de campos nos arrays aItens e aItensCB9
STATIC _POSRECNO   :=1
STATIC _POSITEM    :=2
STATIC _POSCODPRO  :=3
STATIC _POSARMAZEM :=4
STATIC _POSENDERECO:=5
STATIC _POSSLDSEP  :=6
STATIC _POSQTDSEP  :=7
STATIC _POSLOTECTL :=8
STATIC _POSNUMLOTE :=9
STATIC _POSNUMSERIE:=10
STATIC _POSSUBVOL  :=11
STATIC _POSIDETI   :=12
STATIC _POSCFLOTE  :=13
STATIC _POSLOTESUG :=14
STATIC _POSSLOTESUG:=15
STATIC _lPulaItem

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ACDV165  ³ Autor ³ ACD                   ³ Data ³ 03/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Separacao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//CB7_STATUS:
0-Nao Iniciada
1-Em Separacao
2-Separacao Finalizada
3-Em processo embalagem
4-Embalagem Finalizada
5-Gera Nota
6-Imprime nota
7-Imprime Volume
8-Em processo embarque
9-Finalizado
*/

User Function ACDAT003()
	Private cCodOpe  :=CBRetOpe()
	Private cOrdSep  := Space(6)
	Private aItens   := {}
	Private lCB001   := UsaCB0('01')
	Private lCB002   := UsaCB0('02')
	Private cPictQtde:= PesqPict("CB8","CB8_QTDORI")
	Private cNovaLcz := Space(15)
	Private cPreSep  := ""
	Private cOrdOP	 := Space(13)

	If Empty(cCodOpe)
		VTAlert("Operador nao cadastrado","Aviso",.T.,4000)  //"Operador nao cadastrado"###"Aviso"
		Return .F.
	EndIf

	While .t.
		VTClear()
		@ 0,0 VtSay "Separacao"	 //"Separacao"
		cOrdSep := Space(6)
		@ 1,0 VTSay 'Informe a OP:' //'Informe o codigo:'
		@ 2,0 VTGet cOrdOP PICT "@!" Valid VldCodSep()
		VTRead
		If VTLastKey() == 27
			Exit
		EndIf
		Separa()
		exit
	End
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ vldcodsep³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ valida o codigo da ordem de Separacao                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCodSep()
	If Empty(cOrdOP)
		VtKeyBoard(chr(23))
		return .f.
	EndIf

	CB7->(DbSetOrder(5))
	CB7->(DbSeek(xFilial()+cOrdOP))

	cOndaSep := CB7->CB7__PRESE
	cOrdSep  := CB7->CB7_ORDSEP

	//verifica se o operador ja tem uma OP
	cQuery := " SELECT TOP 1 CB7_ORDSEP, CB7_OP,CB7_NUMITE"
	cQuery += " FROM "+RetSqlName("CB7")
	cQuery += " WHERE CB7_FILIAL = '"+xFilial("CB7")+"'"
	cQuery += " AND CB7_OP = '"+cOrdOP+"'"
	cQuery += " AND (CB7_STATUS <> '9' OR (CB7_STATUS = '9' AND CB7__LCALI = '')) AND CB7_OP <> ''"
	cQuery += " AND D_E_L_E_T_ <> '*' AND CB7__TRAVA <> 'S'"
	cQuery += " AND CB7_CODOPE = '"+cCodOpe+"'"
	MEMOWRITE("ACD012.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nRec

	If nRec > 0
		dbSelectArea("TRB")
		dbGoTop()


		cOrdSep := TRB->CB7_ORDSEP
		cMensagem:= "Onda    : "+cOndaSep+ENTER
		cMensagem+= "OP : "+TRB->CB7_OP+ENTER
		cMensagem +="Itens   : "+Space(03)+StrZero(TRB->CB7_NUMITE,3)+ENTER

		CB7->(DbSetOrder(1))
		CB7->(DbSeek(xFilial()+cOrdSep))
		If CB7->CB7_STATUS # "9"
			dbSelectArea("CB7")
			RecLock("CB7")
			CB7->CB7_STATUS := "1"  // em separacao
			If Empty(CB7->CB7_DTINIS)
				CB7->CB7_DTINIS := dDataBase
				CB7->CB7_HRINIS := StrTran(Time(),":","")
			EndIf
			CB7->CB7_STATPA := " "
			CB7->CB7_CODOPE := cCodOpe
			CB7->(MsUnlock())
		EndIf
		VtAlert(cMensagem,"ANOTE OS DADOS",.t.,,3)

		TRB->(dbCloseArea())
	Else 
		TRB->(dbCloseArea())

		//SELECIONA UMA OP PARA O OOPERADOR
		cQuery := " SELECT TOP 1 CB7_ORDSEP, CB7_OP, CB7_NUMITE"
		cQuery += " FROM "+RetSqlName("CB7")
		cQuery += " WHERE CB7_FILIAL = '"+xFilial("CB7")+"'"
		cQuery += " AND CB7__PRESE = '"+cOndaSep+"'"
		cQuery += " AND CB7_STATUS <> '9'"
		cQuery += " AND D_E_L_E_T_ <> '*'"
		//cQuery += " AND CB7_OP <> '' 
		cQuery += " AND CB7_OP = '"+cOrdOP+"'
		cQuery += " AND  (CB7_CODOPE = '' OR CB7_STATPA = '1')  AND CB7__TRAVA <> 'S'"
		cQuery += " ORDER BY  CB7__SEQPR"

		MEMOWRITE("ACD012A.SQL",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

		Count To nRec

		If nRec > 0
			dbSelectArea("TRB")
			dbGoTop()


			cOrdSep := TRB->CB7_ORDSEP
			cMensagem:= "Onda    : "+cOndaSep+ENTER
			cMensagem:= "OP: "+TRB->CB7_OP+ENTER
			cMensagem +="Itens  : "+StrZero(TRB->CB7_NUMITE,3)+ENTER

			CB7->(DbSetOrder(1))
			CB7->(DbSeek(xFilial()+cOrdSep))

			dbSelectArea("CB7")
			RecLock("CB7")
			CB7->CB7_STATUS := "1"  // em separacao
			If Empty(CB7->CB7_DTINIS)
				CB7->CB7_DTINIS := dDataBase
				CB7->CB7_HRINIS := StrTran(Time(),":","")
			EndIf
			CB7->CB7_STATPA := " "
			CB7->CB7_CODOPE := cCodOpe
			CB7->(MsUnlock())

			VtAlert(cMensagem,"ANOTE OS DADOS",.t.,,3)

		Else
			cOrdSep := Space(06)
		EndIf
		TRB->(dbCloseArea())
	EndIf

	If Empty(cOrdSep)
		VtAlert("Nao existe mais Pedidos a separar!","ATENCAO",.t.,4000,3)
		VtKeyBoard(chr(23))
		return .f.
	EndIf

	If CB7->(Eof())
		VtAlert("Ordem de Separacao nao encontrada.","Aviso",.t.,4000,3)  //"Ordem de Separacao nao encontrada."###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If ! "00*" $ CB7->CB7_TIPEXP
		VtAlert("Ordem de Separacao Invalida","Codigo Invalido",.t.,4000,3)  //"Ordem de Separacao Invalida"###"Codigo Invalido"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If CB7->CB7_STATUS == "9" .And. !Empty(CB7->CB7__LCALI)
		VtAlert("Ordem de Separacao Encerrada","Codigo Invalido",.t.,4000,3)  //"Ordem de Separacao Encerrada"###"Codigo Invalido"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If CB7->CB7_STATUS # "0" .AND. CB7->CB7_STATPA == "1" .AND. CB7->CB7_CODOPE # cCodOpe  // SE ESTIVER EM SEPARACAO E PAUSADO SE DEVE VERIFICAR SE O OPERADOR E' O MESMO
		VtBeep(3)
		If !VTYesNo("Ordem Separacao iniciada pelo operador "+CB7->CB7_CODOPE+". Deseja continuar ?","Aviso",.T.) //"Ordem Separacao iniciada pelo operador "###". Deseja continuar ?"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
	ElseIf CB7->CB7_STATUS # "0" .AND. CB7->CB7_STATPA == " " .and. CB7->CB7_CODOPE # cCodOpe  //Ordem Separacao ja esta em andamento...
		VtBeep(3)
		VtAlert("Ordem de Separacao ja esta em andamento por outro operador!","Aviso",.t.,4000) //"Ordem de Separacao ja esta em andamento por outro operador!"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	RecLock("CB7")
	If CB7->CB7_STATUS == "0" .or. Empty(CB7->CB7_STATUS)
		CB7->CB7_STATUS := "1"  // em separacao
		CB7->CB7_DTINIS := dDataBase
		CB7->CB7_HRINIS := StrTran(Time(),":","")
	EndIf
	If !Empty(CB7->CB7_STATPA)  // se estiver pausado tira o STATUS  de pausa
		CB7->CB7_STATPA := " "
	EndIf
	CB7->CB7_CODOPE := cCodOpe
	CB7->(MsUnlock())
	cPreSep := CB7->CB7__PRESE
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CarregaCB8³Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ carrega os itens do cb8 para um array                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarregaCB8(aVetor)
	Local nPos
	Local nX
	Local aItenstmp := {}
	Local aOrdem 	:= {{1,'61000','CARCAÇA'},; //ORDEM, 6 DIGITOS PRODUTO, DESCRICAO
	{2,'61313','ER'},;
	{3,'60000','ER'},;
	{4,'60010','CABO'},;
	{5,'60900','CABO'},;
	{6,'61200','CAIXA P/ 01'},;
	{7,'61205','CAIXA P/ 01'},;
	{8,'60109','BERÇO'},;
	{9,'60200','TUBO INTERNO'},;
	{10,'60205','TUBO INTERNO'},;
	{11,'60099','CONJ. PERFIL'},;
	{12,'61319','MOTOR'},;
	{13,'61215','CAIXA P/ 06'},;
	{14,'60801','BICO'},;
	{15,'61302','CHAVE'},;
	{16,'60005','CONJ. CHAVE DIODO'},;
	{17,'60901','CABINHO'},;
	{18,'60100','AMORTECEDOR'},;
	{19,'60401','TAMPA TRASEIRA'},;
	{20,'60410','GRADE '},;
	{21,'60411','TELA'},;
	{22,'61700','PRESILHA'},;
	{23,'61705','PRESILHA'},;
	{24,'60501','TECLA'},;
	{25,'60101','FOLHA'},;
	{26,'62200','ESPAGUETI'},;
	{27,'60203','ANEL DE TRAVA'},;
	{28,'61907','EIXO'},;
	{29,'61909','MOLA'},;
	{30,'62404','VISOR'}}

	cQuery := " SELECT (R_E_C_N_O_) AS NRECNO,* FROM "+RetSqlName("CB8")
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB8_ORDSEP = '"+cOrdSep+"'"
	cQuery += " AND CB8_FILIAL = '"+xFilial("CB8")+"'"
	cQuery += " AND CB8_SALDOS > 0 AND CB8_OCOSEP = ''"
	//cQuery += " ORDER BY (SUBSTRING(CB8_LCALIZ,6,2)%2),CB8_LCALIZ ASC "     //COLOCA EM ORDEM DE PAR OU IMPAR

	MEMOWRITE("WACD003A.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nRec

	If nRec > 0

		DbSelectArea("TRB")
		dbGoTop()
		While ! Eof()
			nPos := Ascan(aItenstmp,{|x| x[3]+x[4]+x[5]+x[8]+x[9]+x[10]+x[13] == TRB->(CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER+CB8_CFLOTE)})
			nAscan := Ascan(aOrdem,{|x| x[2] == Left(TRB->CB8_PROD,5)})
			If  nPos== 0
				aadd(aItenstmp,{{TRB->NRECNO},;
				TRB->CB8_ITEM,;
				TRB->CB8_PROD,;
				TRB->CB8_LOCAL,;
				TRB->CB8_LCALIZ,;
				TRB->CB8_SALDOS,;
				TRB->CB8_SALDOS,;
				TRB->CB8_LOTECT,;
				TRB->CB8_NUMLOT,;
				TRB->CB8_NUMSER,;
				NIL,;
				NIL,;
				TRB->CB8_CFLOTE,;
				Iif(nAscan == 0, 99,aOrdem[nAscan][1]) })
			Else
				If Ascan(aItenstmp[nPos,1],{|x| x==TRB->NRECNO})==0
					aadd(aItenstmp[nPos,1],TRB->NRECNO)
				EndIf
				aItenstmp[nPos,6]+=TRB->CB8_SALDOS
				aItenstmp[nPos,7]+=TRB->CB8_SLDPRE
			EndIF
			dbSelectArea("TRB")
			DbSkip()
		EndDo
	EndIf
	TRB->(dbCloseArea())
	aItenstmp := aSort(aItenstmp,,,{|x,y| x[14]< y[14]})
	If len(aItenstmp) == 0
		Return .f.
	EndIf
	aVetor := aclone(aItenstmp[1])
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Separa    ³Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ carrega os itens do cb8 para um array                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Separa()
	Local cCodEti
	Local lMV_CONFEND  := GETMV("MV_CONFEND") =="1"  // =1 Solicita a leitura do endereco para conferencia
	Local lMV_CFENDIG  := GetMV('MV_CFENDIG') =="1"  // =1 sempre solicita a leitura do endereco
	Local lMV_OSEP2UN  := GetMV("MV_OSEP2UN") =="1"  // =1 Mostra para separar sempre pela 2 unidade de medida
	Local bkey09       := VTSetKey(09,{|| Informa()},"Informacoes") //"Informacoes"
	Local bkey24       := VTSetKey(24,{|| Estorna()},"Estorno") //"Estorno"
	Local lGeraTermino :=.t.
	Private cArmazem   := Space(2)
	Private cEndereco  := Space(15)
	Private cLoteNew   := Space(10)
	Private cSLoteNew  := Space(6)
	Private cDivItemPv := GetMV("MV_DIVERPV")  // codigo da divergencia
	Private nQtdLida   := 0
	_lPulaItem := .f.

	While .t.
		If ! CarregaCB8(aItens)
			If VTYesNo('Separacao finalizada, confirma a saida?','Atencao',.T.)  //'Separacao finalizada, confirma a saida?'###'Atencao'
				If !Empty(cOrdSep)
					dbSelectArea("CB7")
					DbSetOrder(1)
					If DbSeek(xFilial("CB7")+cOrdSep)
						If CB7->CB7_STATUS # "9"
							RecLock("CB7",.f.)
							CB7->CB7_STATUS := "9"
							CB7->CB7_DTFIMS := dDataBase
							CB7->CB7_HRFIMS := StrTran(Time(),":","")
							CB7->(MsUnLock())
						EndIf
					EndIf
				EndIf
				lGeraTermino:= .T.
				Exit
			Else
				Estorna()
				Loop
			EndIF
		EndIf
		nQtdLida := 0
		If Empty(aItens[_POSSLDSEP])  // se for branco significa que ja foi separado
			Loop
		EndIf
		If ! aItens[_POSARMAZEM]+aItens[_POSENDERECO] == cArmazem+cEndereco
			// Efetua a leitura da etiqueta de endereco
			If ! Endereco(lMV_CONFEND,lMV_CFENDIG,@cArmazem,@cEndereco)
				If QtdComp(aItens[_POSQTDSEP])<>QtdComp(aItens[_POSSLDSEP])

					If VTYesNo('Confirma a saida sem Finalizar a Separacao?','Atencao',.T.)  //'Confirma a saida sem geracao parciais das ordens?'###'Atencao'
						lGeraTermino:= .f.
						exit
					EndIf
					_lPulaItem:= .t.
					If ! PulaItem()
						loop
					EndIf
				EndIf
				If VTYesNo('Confirma a saida?','Atencao',.T.)  //'Confirma a saida?'###'Atencao'
					CB7->(DbSetOrder(1))
					CB7->(DbSeek(xFilial("CB7")+cOrdSep))
					RecLock("CB7",.f.)
					CB7->CB7_STATPA := "1"
					VtAlert("Separacao em Pausa!!!","Aviso",.t.,3000,3)  //"Etiqueta invalida"###"Aviso"
					CB7->(msUnlock())
					exit
				EndIf
				Loop
			EndIf
		EndIf
		//mostra na tela o produto a ser separada
		Tela(lMV_OSEP2UN)

		//solicita a leitura da etiqueta referente a produto
		If ! EtiqProduto()
			If QtdComp(aItens[_POSQTDSEP])<>QtdComp(aItens[_POSSLDSEP])
				If VTYesNo('Confirma a saida sem Finalizar a Separacao?','Atencao',.T.)  //'Confirma a saida sem geracao parciais das ordens?'###'Atencao'
					lGeraTermino:= .f.
					exit
				EndIf
				_lPulaItem:= .t.
				If ! PulaItem()
					loop
				EndIf
			EndIf
			If VTYesNo('Confirma a saida?','Atencao',.T.)  //'Confirma a saida?'###'Atencao'
				CB7->(DbSetOrder(1))
				CB7->(DbSeek(xFilial("CB7")+cOrdSep))
				RecLock("CB7",.f.)
				CB7->CB7_STATPA := "1"
				VtAlert("Separacao em Pausa!!!","Aviso",.t.,3000,3)  //"Etiqueta invalida"###"Aviso"
				CB7->(msUnlock())

				Exit
			EndIf
			Loop
		EndIf
		// verifica se pula o item
		If PulaItem()
			Loop
		EndIf

		If ! CBProdUnit(aItens[_POSCODPRO])  .or. lCB001
			cCodEti := CB0->CB0_CODETI
		Else
			cCodEti := NIL
		Endif

		Reclock('CB7')
		CB7->CB7_STATUS := "1"  // inicio separacao
		CB7->(MsUnLock())
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aItens[_POSCODPRO]))

		If ! Grava(cCodEti)
			Loop
		EndIf

		If ! Empty(aItens[_POSSLDSEP])
			Loop
		EndIf
		If lMV_CFENDIG
			cArmazem   := Space(2)
			cEndereco  := Space(15)
		EndIf
	EndDo
	If lGeraTermino
		AnalisaTermino()
	Else
		Reclock('CB7')
		CB7->CB7_STATPA := "1"  // Pausa
		CB7->(MsUnLock())
	EndIf
	VTSetKey(09,bkey09)
	VTSetKey(24,bkey24)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Endereco ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Inicio do Envio para o endereco                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Endereco(lMV_CONFEND,lMV_CFENDIG,cArmazem,cEndereco)
	Local aTela    := VtSave()
	Local cEtiqEnd := Space(20)

	VTClear()
	cArmazem   := Space(2)
	cEndereco  := Space(15)
	cEtiqEnd   := Space(20)

	//QUANDO FOR ARMAZEM 02 E ENDERECO PROD, JÁ TRAZ PREENCHIDO
	//QUANDO PASSAR A UTILIZAR ENDEREÇO CORRETAMENTE, TIRAR FORA ESTE TRECHO
	If aItens[_POSARMAZEM] =="02" .And. AllTrim(aItens[_POSENDERECO]) == "PROD"
		cArmazem   := aItens[_POSARMAZEM]
		cEndereco  := aItens[_POSENDERECO]
		cEtiqEnd   := aItens[_POSARMAZEM]+aItens[_POSENDERECO]
		VtAlert("Endereco 02 - PROD","Aviso",.t.,2000,3) 

	Else

		@ 1,0 VTSay 'Va para o endereco' //'Va para o endereco'
		@ 2,0 VTSay aItens[_POSARMAZEM]+'-'+aItens[_POSENDERECO]
		If ! lMV_CONFEND
			@ 6,0 VTPause 'Enter para continuar' //'Enter para continuar'
		Else
			@ 4,0 VTSay 'Leia o endereco' //'Leia o endereco'
			If lCB002
				@ 5,0 VTGet cEtiqEnd pict '@!' valid VldEnd(@cArmazem,@cEndereco,cEtiqEnd)
			Else
				@ 5,0 VTGet cArmazem pict '@!' valid ! Empty(cArmazem)
				@ 5,3 VTSay "-" VTGet cEndereco pict '@!' valid VtLastKey()==5 .or. VldEnd(@cArmazem,@cEndereco)
			EndIf
			VTRead
			If VTLastkey() == 27
				Return .f.
			EndIf
		EndIf
	EndIf
	cArmazem := aItens[_POSARMAZEM]
	cEndereco:= aItens[_POSENDERECO]
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ VldEnd   ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Validacao do Endereco                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEnd(cArmazem,cEndereco,cEtiqEnd)
	Local aRet
	VtClearBuffer()
	If Empty(cEtiqEnd) .and. lCB002
		VtAlert("Etiqueta invalida","Aviso",.t.,2000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If Empty(cArmazem) // se cArmazem == Empty entao e' etiqueta de endereco com CB0
		aRet := CBRetEti(cEtiqEnd,'02')
		If len(aRet) == 0
			VtAlert("Etiqueta invalida","Aviso",.t.,2000,3)  //"Etiqueta invalida"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cArmazem  := aRet[2]   // somente esta sendo atribuido para posteriormnete ser comparado com aItens
		cEndereco := aRet[1]
	EndIf
	If !(cArmazem+cEndereco == aItens[_POSARMAZEM]+aItens[_POSENDERECO] )
		VtAlert("Endereco incorreto","Aviso",.t.,2000,3) 	 //"Endereco incorreto"###"Aviso"
		cArmazem  := Space(02)   // somente esta sendo atribuido para posteriormnete ser comparado com aItens
		cEndereco := Space(15)
		VTClearGet("cArmazem")
		VTClearGet("cEndereco")
		VTGetSetFocus("cArmazem")
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If !CBEndLib(cArmazem,cEndereco) // verifica se o endereco esta liberado ou bloqueado
		VtAlert("Endereco Bloqueado.","Aviso",.t.,2000,3) //"Endereco Bloqueado."###"Aviso"
		VTClearGet("cArmazem")
		VTClearGet("cEndereco")
		VTGetSetFocus("cArmazem")
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
Return .T.
//---TERMINO das funcoes referente ao endereco -------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³  Tela    ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Montagem da tela Principal                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Tela(lMV_OSEP2UN)
	Local cSay
	Local nQtdCx

	VTClear()
	cSay := 'Separe ' //'Separe '
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aItens[_POSCODPRO]))

	If lMV_OSEP2UN
		nQtdCX:= If(Empty(RetFldProd(SB1->B1_COD,"B1_QE")),1,RetFldProd(SB1->B1_COD,"B1_QE"))
		If ExistBlock('CBRQEESP')
			nQtdCX:=ExecBlock('CBRQEESP',,,SB1->B1_COD)
		EndIf
		If aItens[_POSSLDSEP]/nQtdCX < 1
			cSay +=Padr(Alltrim(Str(aItens[_POSSLDSEP],TamSx3("CB8_QTDORI")[1],TamSx3("CB8_QTDORI")[2]))+' '+SB1->B1_UM,20)//If(aItens[_POSSLDSEP]==1,' item ',' itens '),20) //' item '###' itens '
		Else
			cSay +=Padr(Alltrim(Str(aItens[_POSSLDSEP]/nQtdCX,TamSx3("CB8_QTDORI")[1],TamSx3("CB8_QTDORI")[2]))+If(aItens[_POSSLDSEP]/nQtdCX==1," Volume"," Volumes"),20) //" Volume"###" Volumes"
		EndIf
	Else
		cSay +=Padr(Alltrim(Str(aItens[_POSSLDSEP],TamSx3("CB8_QTDORI")[1],TamSx3("CB8_QTDORI")[2]))+' '+SB1->B1_UM,20)//If(aItens[_POSSLDSEP]==1,' item ',' itens '),20) //' item '###' itens '
	EndIf

	@ 0,0 VTSay cSay
	@ 1,0 VTSay "Codigo: " +aItens[_POSCODPRO]
	@ 2,0 VTSay Left(SB1->B1_DESC,20)
	@ 3,0 VTSay SubStr(SB1->B1_DESC,21,20)
	If Rastro(aItens[_POSCODPRO],"L")
		@ 4,0 VTSay 'Lote: '+ aItens[_POSLOTECTL]
	ElseIf Rastro(aItens[_POSCODPRO],"S")
		@ 4,0 VTSay 'Lote       SubLote' //'Lote       SubLote'
		@ 5,0 VTSay aItens[_POSLOTECTL]+' '+aItens[_POSNUMLOTE]
	EndIf
	If ! Empty(aItens[_POSNUMSERIE])
		@ 6,0 VTSay "Numero de Serie " //"Numero de Serie "
		@ 7,0 VTSay aItens[_POSNUMSERIE]
		@ 8,0 VTPause 'Enter para continuar' //'Enter para continuar'
		VTClear()
	EndIf
Return

//---TERMINO das funcao de montagem da tela princiapal ------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³EtiqProduto³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Leitura das etiquetas de produto                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//---INICIO das funcoes referente a leitura da etiqueta de produto------

Static Function EtiqProduto()
	Local lGranel    := ! CBProdUnit(aItens[_POSCODPRO])  // granel
	Local lSerie     := ! Empty(aItens[_POSNUMSERIE])
	Local cEtiqCaixa := Space(TamSx3("CB0_CODET2")[1])
	Local cEtiqAvulsa:= Space(TamSx3("CB0_CODET2")[1])
	Local cEtiqProd  := Space(TamSx3("CB0_CODET2")[1])
	Local cProduto   := Space(48)
	Local nQtde := 1
	Local bKey16 := VtSetKey(16)

	VtSetKey(16,{|| _lPulaItem:= .t.,VtKeyboard(CHR(13)) },"Pula Item")  // CTRL+P //"Pula Item"

	// solicitando a leitura da etiqueta
	If lGranel
		/*
		@ 6,0 VTSay "Leia a caixa" //"Leia a caixa"
		@ 7,0 VtGet cEtiqCaixa pict '@!' Valid VldCaixa(cEtiqCaixa)
		VTRead
		If VTLastkey() == 27
		VtSetKey(16, bKey16,"")
		Return .f.
		EndIf
		*/
		@ 6,0 VTClear to 7,19
		@ 6,0 VTSay "Leia a etiq. avulsa" //"Leia a etiq. avulsa"
		@ 7,0 VtGet cEtiqAvulsa pict '@!' Valid VldEtiqAvulsa(cEtiqAvulsa)
	Else
		If lCB001
			If lSerie
				@ 1,0 VTSay 'Leia a etiqueta' //'Leia a etiqueta'
				@ 2,0 VTGet cEtiqProd pict '@!' Valid VldEti(cEtiqProd)
			Else
				@ 6,0 VTSay 'Leia a etiqueta' //'Leia a etiqueta'
				@ 7,0 VTGet cEtiqProd pict '@!' Valid VldEti(cEtiqProd)
			EndIf
		Else
			If lSerie
				@ 1,0 VTSay 'Qtde ' VtGet nQtde pict cPictQtde valid VldQtde(nQtde,lSerie) when VtLastkey()==5  //'Qtde '
				@ 2,0 VTSay 'Leia o produto' //'Leia o produto'
				@ 3,0 VTGet cProduto pict '@!' VALID VTLastkey() == 5 .or. VldProd(cProduto,nQtde,lSerie)
			Else
				@ 5,0 VTSay 'Qtde ' VtGet nQtde pict cPictQtde valid VldQtde(nQtde,lSerie) when VtLastkey()==5  //'Qtde '
				@ 6,0 VTSay 'Leia o produto' //'Leia o produto'				
				@ 7,0 VTGet cProduto pict '@!' VALID VTLastkey() == 5 .or. VldProd(cProduto,nQtde,lSerie)
			EndIf
		Endif
	EndIf
	VTRead
	VtSetKey(16, bKey16,"")
	If VTLastkey() == 27
		Return .f.
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³VldEtiqAvulsa³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Validacao das etiquetas avulsas                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEtiqAvulsa(cEtiqAvulsa)
	Local nQE 
	Local cLote    := Space(10)
	Local cSLote   := Space(6)

	Local aEtiqueta:={}
	If _lPulaItem
		Return .t.
	EndIf 
	If Empty(cEtiqAvulsa)
		Return .f.
	EndIf
	/*
	If Len(CBRetEti(cEtiqAvulsa)) > 0
	VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
	VtKeyboard(Chr(20))  // zera o get
	Return .F.
	EndIf
	*/
	dbSelectArea("SB1")
	dbSetOrder(5)
	If !dbSeek(xFilial()+cEtiqAvulsa)
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	ElseIf aItens[_POSCODPRO] # SB1->B1_COD
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf



	CBGrvEti("01",{aItens[_POSCODPRO],0,cCodOpe,,,,,,,,CB7->CB7_OP},Padr(cEtiqAvulsa,10))
	nQE  :=CBQtdEmb(aItens[_POSCODPRO])
	If Empty(nQE)
		VtAlert("Quantidade invalida","Aviso",.t.,4000,3) //"Quantidade invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		RecLock('CB0',.f.)
		CB0->(DbDelete())
		CB0->(MSUnlock())
		Return .F.
	EndIf
	If nQE > aItens[_POSSLDSEP]
		VtAlert("Quantidade maior que solicitado","Aviso",.t.,4000,3)  //"Quantidade maior que solicitado"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		RecLock('CB0',.f.)
		CB0->(DbDelete())
		CB0->(MSUnlock())
		Return .f.
	EndIf
	CBGrvEti("01",{NIL,nQE,NIL},Padr(cEtiqAvulsa,10))
	If CBRastro(aItens[_POSCODPRO],aItens[_POSLOTECTL],@cSLote)
		If aItens[_POSCFLOTE] == "1"
			If ! cLote+cSLote == aItens[_POSLOTECTL]+aItens[_POSNUMLOTE]
				VtAlert("Lote invalido","Aviso",.t.,4000,3)  //"Lote invalido"###"Aviso"
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
		EndIf
		If  GetMv('MV_ESTNEG') =='N'
			nSaldo := SaldoSBF(aItens[_POSARMAZEM],aItens[_POSENDERECO],aItens[_POSCODPRO],,cLote,cSLote,.T.)
			If nQE > nSaldo
				VtAlert("Saldo em estoque insuficiente","Aviso",.t.,4000,3)  //"Saldo em estoque insuficiente"###"Aviso"
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
		Else
			If ! CBExistLot(aItens[_POSCODPRO],aItens[_POSARMAZEM],aItens[_POSENDERECO],cLote,cSLote)
				VtAlert("Lote nao existe","Aviso",.t.,4000,3)  //"Lote nao existe"###"Aviso"
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
		EndIf
		aEtiqueta:= CBRetEti(Padr(cEtiqAvulsa,10),"01")
		aEtiqueta[16]:=cLote
		aEtiqueta[17]:=cSLote
		CBGrvEti("01",aEtiqueta,Padr(cEtiqAvulsa,10))
	Else
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	cLoteNew:= cLote
	cSLoteNew:=cSLote
	nQtdLida := nQE
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³VldEti³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Validacao das etiquetas  		                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEti(cEtiqProd)
	Local cLote := Space(10)
	Local cSLote:= Space(6)
	Local cNewEtiq
	Local aEtiqueta:={}
	Local aNewEtiq :={}
	Local aItensTemp:={}
	Local lACD165VE:=ExistBlock('ACD165VE')

	If ! CarregaCB8(aItensTemp) .or. (aItensTemp[_POSARMAZEM]+aItensTemp[_POSENDERECO]+aItensTemp[_POSCODPRO]+aItensTemp[_POSLOTECTL]+aItensTemp[_POSNUMLOTE]+aItensTemp[_POSNUMSERIE] # ;
	aItens[_POSARMAZEM]+aItens[_POSENDERECO]+aItens[_POSCODPRO]+aItens[_POSLOTECTL]+aItens[_POSNUMLOTE]+aItens[_POSNUMSERIE])
		VtAlert("Separacao deste produto foi finalizado por outro usuario","Aviso",.t.,5000,3)  //"Separacao deste produto foi finalizado por outro usuario"###"Aviso"
		Return .t.
	EndIf
	If _lPulaItem
		Return .t.
	EndIf
	If Empty(cEtiqProd)
		Return .f.
	EndIf

	aEtiqueta:= CBRetEti(cEtiqProd,"01")
	If lACD165VE
		aEtiqueta:=ExecBlock('ACD165VE',,,{aEtiqueta})
	EndIf
	If Empty(aEtiqueta)
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	CB8->(DbSetOrder(1))
	If CB8->(DbSeek(xFilial("CB8")+cOrdSep+CB0->CB0_CODETI))
		VtAlert("Etiqueta ja foi lida","Aviso",.t.,4000,3)  //"Etiqueta ja foi lida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If ! aItens[_POSARMAZEM]+ aItens[_POSENDERECO] == aEtiqueta[10]+aEtiqueta[9]
		VtAlert("Endereco diferente","Aviso",.t.,4000,3)  //"Endereco diferente"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If !  aItens[_POSCODPRO] == aEtiqueta[1]
		VtAlert("Produto diferente","Aviso",.t.,4000,3)  //"Produto diferente"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If ! CBProdLib(aEtiqueta[10],aEtiqueta[1])
		VTKeyBoard(chr(20))
		Return .f.
	EndIf

	cLote  := aEtiqueta[16]
	cSLote := aEtiqueta[17]
	If aItens[_POSCFLOTE] =="1"
		If ! cLote+cSLote == aItens[_POSLOTECTL]+aItens[_POSNUMLOTE]
			VtAlert("Lote invalido","Aviso",.t.,4000,3) //"Lote invalido"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
	EndIf
	If CB0->CB0_NUMSER # aItens[_POSNUMSERIE]
		VtBeep(3)
		VtAlert("Etiqueta Invalida !!!","Aviso",.t.,3000) //"Etiqueta Invalida !!!"###"Aviso"
		VtAlert("Informe a etiqueta com o Numero de Serie "+aItens[_POSNUMSERIE]   ,"Aviso",.t.,4000) //"Informe a etiqueta com o Numero de Serie "###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .f.
	EndIf
	If ExistBlock('ACD170VE')
		aEtiqueta:=ExecBlock('ACD170VE',,,aEtiqueta)
		If Empty(aEtiqueta)
			Return .f.
		EndIf
	EndIf
	If CBQtdVar(aEtiqueta[1]) .and. aEtiqueta[2] > aItens[_POSSLDSEP]
		cNewEtiq:= GeraNewEti(aItens[_POSSLDSEP])
		aNewEtiq:= CBRetEti(cNewEtiq,"01")
	ElseIf aEtiqueta[2] > aItens[_POSSLDSEP]
		VtAlert("Quantidade maior que necessario","Aviso",.t.,4000,3)  //"Quantidade maior que necessario"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If Empty(aNewEtiq)
		nQtdLida := aEtiqueta[2]
		cLoteNew := cLote
		cSLoteNew:= cSLote
	Else
		cEtiqProd:= CB0->CB0_CODETI
		nQtdLida := aNewEtiq[2]
		cLoteNew := aNewEtiq[16]
		cSLoteNew:= aNewEtiq[17]
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProd   ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao do produto                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldProd(cProduto,nQtde,lSerie)
	Local aRet   := {}
	Local nSaldo := 0
	Local cLote  := Space(10)
	Local cSLote := Space(6)
	Local cNumSer:= Space(20)
	Local lACD165VE:=ExistBlock('ACD165VE')

	If _lPulaItem
		Return .t.
	EndIf
	If Empty(cProduto)
		Return .f.
	EndIf

	If !CBLoad128(@cProduto)
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If ! CbRetTipo(cProduto) $ "EAN8OU13-EAN14-EAN128"
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	aRet     := CBRetEtiEan(cProduto)
	If len(aRet) == 0 .Or. aRet[1] == Nil
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	cCodPro := aRet[1]


	If ! CBProdLib(cArmazem,cCodPro)
		VTKeyBoard(chr(20))
		Return .f.
	EndIf

	If !(aItens[_POSCODPRO] == cCodPro)
		VtAlert("Etiqueta de produto diferente","Aviso",.t.,4000,3)  //"Etiqueta de produto diferente"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf


	If lACD165VE
		aRet:=ExecBlock('ACD165VE',,,{aRet})
	EndIf
	If len(aRet) == 0
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	cLote := aRet[3]
	If ! CBProdLib(cArmazem,aRet[1])
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	cNumSer:= aRet[5]	 // Numero de Serie
	If ! CBRastro(aItens[_POSCODPRO],aItens[_POSLOTECTL],@cSLote)
		VTKeyBoard(chr(20))
		Return .f.
	EndIf

	If aItens[_POSCFLOTE] =="1"
		If ! cLote+cSLote == aItens[_POSLOTECTL]+aItens[_POSNUMLOTE]
			VtAlert("Lote invalido","Aviso",.t.,4000,3)  //"Lote invalido"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
	EndIf
	If lSerie
		If ! CBNumSer(@cNumSer,aItens[_POSNUMSERIE])
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	EndIf
	If aRet[2]*nQtde > aItens[_POSSLDSEP]
		VtAlert("Quantidade maior que necessario","Aviso",.t.,4000,3)  //"Quantidade maior que necessario"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If CB7->CB7_ORIGEM # "2"
		If GetMv('MV_ESTNEG') =='N'
			nSaldo := SaldoSBF(aItens[_POSARMAZEM],aItens[_POSENDERECO],aItens[_POSCODPRO],,cLote,cSLote,.T.)
			If aRet[2]*nQtde > nSaldo
				VtAlert("Saldo em estoque insuficiente","Aviso",.t.,4000,3)  //"Saldo em estoque insuficiente"###"Aviso"
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
		Else
			If ! CBExistLot(aItens[_POSCODPRO],aItens[_POSARMAZEM],aItens[_POSENDERECO],cLote,cSLote)
				VtAlert("Lote nao existe","Aviso",.t.,4000,3)  //"Lote nao existe"###"Aviso"
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
		EndIf
	EndIf
	nQtdLida := aRet[2]*nQtde
	cLoteNew:= cLote
	cSLoteNew:=cSLote
Return .t.

//---TERMINO das funcoes referente a leitura da etiqueta de produto-----

//---INICIO das funcoes referente ao pulo do item -----
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PulaItem ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Pula o item                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PulaItem()
	Local aRec, aSvTela,cOcoSep
	Local nX
	If ! _lPulaItem
		Return .f.
	EndIf
	_lPulaItem := .f.

	aSvTela := VtSave()
	CB8->(DbGoto(aItens[_POSRECNO,1]))
	cOcoSep := CB8->CB8_OCOSEP
	CB4->(DbSetOrder(1))
	CB4->(DbSeek(xFilial("CB4")+cOcoSep))
	VTClear
	@ 2,0 VTSay 'Informe o codigo' //'Informe o codigo'
	@ 3,0 VTSay 'da divergencia:' //'da divergencia:'
	@ 4,0 VtGet cOcoSep pict '@!' Valid VldOcoSep(cOcoSep) F3 "CB4"
	VtRead()
	VtRestore(,,,,aSvTela)
	If VtLastKey() == 27
		Return .f.
	EndIf
	For nX:= 1 to len(aItens[_POSRECNO])
		CB8->(DbGoto(aItens[_POSRECNO,nX]))
		RecLock("CB8")
		CB8->CB8_OCOSEP := cOcoSep
		CB8->(MsUnlock())
	Next
	If CB7->CB7_DIVERG # "1"   // marca divergencia na ORDEM DE SEPARACAO para que esta seja arrumada
		CB7->(RecLock("CB7"))
		CB7->CB7_DIVERG := "1"  // sim
		CB7->(MsUnlock())
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ VldOcoSep³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Validacao da ocorrencia informada no pulo do item          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldOcoSep(cOcoSep)

	If Empty(cOcoSep)
		VtKeyBoard(chr(23))
	EndIf

	CB4->(DBSetOrder(1))
	If ! CB4->(DbSeek(xFilial("CB4")+cOcoSep))
		VtAlert("Ocorrencia nao cadastrada","Aviso",.t.,4000,3)  //"Ocorrencia nao cadastrada"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

Return .T.

//---TERMINO das funcoes referente ao pulo do item -----

//---INICIO das funcoes referente a gravacao do item -----

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³   Grava  ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Realiza a gravacao dos itens lidos                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Grava(cCodCB0)
	Local nY
	Local nSaldoCB8
	DefauLt cCodCB0 := Space(10)

	For nY:= 1 to len(aItens[_POSRECNO])
		CB8->(DbGoto(aItens[_POSRECNO,nY]))
		nRecCB8 := CB8->(Recno())
		nSaldoCB8:= CB8->CB8_SALDOS
		If empty(nSaldoCB8)
			Loop
		EndIf
		CB9->(DbSetOrder(10))
		CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+cLoteNew+cSLoteNew+CB8_NUMSER+CB8_LOTECT+CB8_NUMLOT)+Space(10)+cCodCB0+CB8->CB8_PEDIDO))
		If ! CB9->(Eof())
			If lCB001
				VtAlert("Codigo ja Lido","Aviso",.t.,4000,3)  //"Codigo ja Lido"###"Aviso"
				Return .F.
			EndIf
			RecLock("CB9",.F.)
		Else
			RecLock("CB9",.T.)
			CB9->CB9_FILIAL := xFilial("CB9")
			CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
			CB9->CB9_CODETI := cCodCB0
			CB9->CB9_PROD   := CB8->CB8_PROD
			CB9->CB9_CODSEP := CB7->CB7_CODOPE
			CB9->CB9_ITESEP := CB8->CB8_ITEM
			CB9->CB9_SEQUEN := CB8->CB8_SEQUEN
			CB9->CB9_LOCAL  := CB8->CB8_LOCAL
			CB9->CB9_LCALIZ := CB8->CB8_LCALIZ
			CB9->CB9_LOTECT := cLoteNew
			CB9->CB9_NUMLOT := cSLoteNew
			CB9->CB9_NUMSER := CB8->CB8_NUMSER
			CB9->CB9_LOTSUG := CB8->CB8_LOTECT
			CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
			CB9->CB9_PEDIDO := CB8->CB8_PEDIDO

		EndIf
		CB9->CB9_QTESEP += If(nQtdLida > nSaldoCB8,nSaldoCB8,nQtdLida)
		CB9->CB9_STATUS := "1"  // EM ABERTO
		CB9->(MsUnlock())
		RecLock("CB8")
		CB8->CB8_SALDOS -= If(nQtdLida > nSaldoCB8,nSaldoCB8,nQtdLida)
		CB8->(MsUnlock())


		aItens[_POSSLDSEP] -= If(nQtdLida > nSaldoCB8,nSaldoCB8,nQtdLida)
		nQtdLida -= If(nQtdLida > nSaldoCB8,nSaldoCB8,nQtdLida)
		If nQtdLida == 0
			Exit
		Endif
	Next
Return .t.

//---TERMINO das funcoes referente a gravacao do item -----

//---INICIO da funcao referente ao informa -----

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Informa  ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Informa as etiquetas lidas                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Informa()
	Local aCab,aSize,aTela := VTSAVE()
	Local nOpc
	Local aTemp:={}
	Local nX
	Local aItenstmp:={}

	VTCLear()
	@ 0,0 VTSAY "Informacoes" //"Informacoes"
	@ 1,0 VTSay 'Selecione:'              //'Selecione:'
	nOpc:=VTaChoice(3,0,4,VTMaxCol(),{"A Separar","Separados"})  //"A Separar"###"Separados"
	VtRestore(,,,,aTela)
	If VtLastKey() == 27
		Return
	EndIf
	VTCLear()
	If nOpc ==1
		CB8->(DbSetOrder(3))
		CB8->(DbSeek(xFilial("CB8")+cOrdSep))
		While ! CB8->(Eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == cOrdSep
			nPos := Ascan(aItenstmp,{|x| x[3]+x[4]+x[5]+x[8]+x[9]+X[12] == CB8->(CB8_PROD+CB8_LOCAL+CB8->CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_CFLOTE)})
			If  nPos== 0
				aadd(aItenstmp,{{CB8->(Recno())},;
				CB8->CB8_ITEM,;
				CB8->CB8_PROD,;
				CB8->CB8_LOCAL,;
				CB8->CB8_LCALIZ,;
				CB8->CB8_SALDOS,;
				CB8->CB8_SLDPRE,;
				CB8->CB8_LOTECT,;
				CB8->CB8_NUMLOT,;
				NIL,;
				NIL,;
				CB8->CB8_CFLOTE })
			Else
				If Ascan(aItenstmp[nPos,1],{|x| x==CB8->(Recno())})==0
					aadd(aItenstmp[nPos,1],CB8->(Recno()))
				EndIf
				aItenstmp[nPos,6]+=CB8->CB8_SALDOS
				aItenstmp[nPos,7]+=CB8->CB8_SLDPRE
			EndIf
			CB8->(DbSkip())
		EndDo
		For nX:= 1 to Len(aItenstmp)
			aadd(aTemp,{aItenstmp[nX,_POSCODPRO],;
			Transform(aItenstmp[nX,_POSQTDSEP],cPictQtde),;
			Transform(aItenstmp[nX,_POSSLDSEP],cPictQtde),;
			aItenstmp[nX,_POSARMAZEM],;
			aItenstmp[nX,_POSENDERECO],;
			aItenstmp[nX,_POSLOTECTL],;
			aItenstmp[nX,_POSNUMLOTE]})
		Next
		aCab  := {"Produto","Quantidade","Saldo","Armazem","Endereco","Lote","Sub-Lote"} //"Produto"###"Quantidade"###"Saldo"###"Armazem"###"Endereco"###"Lote"###"Sub-Lote"
		aSize := {15,len(cPictQtde),len(cPictQtde),8,15,10,8}
		VTaBrowse(0,0,VtMaxRow(),vtMaxCol(),aCab,aTemp,aSize)
	Else
		CB9->(DbSetOrder(6))
		CB9->(DbSeek(xFilial("CB9")+cOrdSep))
		While CB9->(! Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+cOrdSep)
			nPos:= Ascan(aTemp,{|x| x[1]+x[3]+x[4]+x[5]+x[6]+x[7] == CB9->(CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_CODETI)})
			If nPos == 0
				aadd(aTemp,{CB9->CB9_PROD,0,CB9->CB9_LOCAL,CB9->CB9_LCALIZ,CB9->CB9_LOTECT,CB9->CB9_NUMLOT,CB9->CB9_CODETI})
				nPos:= Len(aTemp)
			Endif
			aTemp[nPos,2]+= CB9->CB9_QTESEP
			CB9->(DbSkip())
		Enddo
		aTemp := aSort(aTemp,,,{|x,y| x[1]+x[3]+x[4]+x[5]+x[6]+x[7] < y[1]+y[3]+y[4]+y[5]+y[6]+y[7]})
		aCab  := {"Produto","Quantidade","Armazem","Endereco","Lote","Sub-Lote","Etiqueta"} //"Produto"###"Quantidade"###"Armazem"###"Endereco"###"Lote"###"Sub-Lote"###"Etiqueta"
		aSize := {15,len(cPictQtde),08,15,10,8,20}
		VTaBrowse(0,0,VtMaxRow(),vtMaxCol(),aCab,aTemp,aSize)
	EndIf
	VtRestore(,,,,aTela)
Return

//---TERMINO da funcao referente ao informa -----

//---INICIO da funcao que analisa se terminou e gera as ordens de separacoes  -----

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³AnalisaTermino³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Analisa as Ordens de separacao a ser geradas                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AnalisaTermino()
	Local cOrigem  := CB7->CB7_ORIGEM
	Local aSep 		:= {}
	Local np1
	Local nX,nY
	Local aOrdSep	  := {}
	Local cPedido 	  := Space(6)
	Local cArm		  := Space(2)
	Local cMsgParcial:= ""
	Local aTravas	:= {}
	Local cArmOri	:= "02"
	Local aTransf	:= {}
	Local dValid    := Ctod("")

	Private cTipExp  := CB7->CB7_TIPEXP
	Private cCond    := CB7->CB7_COND
	Private cLojaEnt := CB7->CB7_LOJENT
	Private cTransp  := CB7->CB7_TRANSP
	Private cAgreg   := CB7->CB7_AGREG
	PRIVATE lMsErroAuto := .F.

	CB8->(DbSetOrder(3))
	CB8->(DbSeek(xFilial("CB8")+cOrdSep))
	While ! CB8->(Eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == cOrdSep
		If ! Empty(CB8->CB8_SALDOS) .or. ! Empty(CB8->CB8_OCOSEP)
			cMsgParcial:=" Parciais" //" Parciais"
		EndIf
		If CB8->CB8_QTDORI==CB8->CB8_SALDOS
			CB8->(DbSkip())
			Loop
		EndIf

		If cOrigem == "1" // Pedido
			SC6->( dbSetOrder( 1 ) )
			SC6->(DbSeek(xFilial("SC6") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_PROD))
			If "11*" $ cTipExp
				cPedido:=Space(6)
			Else
				cPedido:=CB8->CB8_PEDIDO
			EndIf
			If "08*" $ cTipExp
				cArm   :=CB8->CB8_LOCAL
			EndIf
			nP1:= Ascan(aSep,{|x| x[1]+X[2]+x[3]+x[4] == cPedido+SC6->C6_CLI+SC6->C6_LOJA+cArm})
			If nP1 ==0
				aadd(aSep,{cPedido,SC6->C6_CLI,SC6->C6_LOJA,cArm,{}})
				nP1:= Len(aSep)
			EndIf
			CB8->(aadd(aSep[nP1,5],{CB8_ITEM,CB8_SEQUEN,CB8_PROD,CB8_PEDIDO,CB8_LOCAL,CB8_SLDPRE,CB8_SALDOS,CB8_LCALIZ,CB8_LOTECT,CB8_NUMLOT,CB8_NUMSER,CB8_CFLOTE,Recno()}))
		Elseif cOrigem == "3" // Ordem de Producao
			SC2->(DbSetOrder(1))
			SC2->(DbSeek(xFilial("SC2")+CB8->CB8_OP))
			If "08*" $ cTipExp  // gera Ordem de Separacao com todos os Armazens
				cArm :=Space(2)
			Else
				cArm:= CB8->CB8_LOCAL
			EndIf
			nP1:= Ascan(aSep,{|x| x[1]+X[2] == CB8->CB8_OP+cArm})
			If nP1 ==0
				aadd(aSep,{CB8->CB8_OP,cArm,{}})
				nP1:= Len(aSep)
			EndIf
			CB8->(aadd(aSep[nP1,3],{CB8_ITEM,CB8_SEQUEN,CB8_PROD,CB8_OP,CB8_LOCAL,CB8_SLDPRE,CB8_SALDOS,CB8_LCALIZ,CB8_LOTECT,CB8_NUMLOT,CB8_NUMSER,CB8_CFLOTE,Recno()}))
		Endif
		CB8->(DbSkip())
	EndDo
	If Empty(aSep)
		Return
	EndIf

	cTipExp := StrTran(cTipExp,"09*","")

	CB7->(DbSetOrder(1))
	CB7->(DbSeek(xFilial("CB7")+cOrdSep))
	RecLock("CB7",.f.)
	If Empty(cMsgParcial)
		CB7->CB7_STATUS := "9"
		CB7->CB7_DTFIMS := dDataBase
		CB7->CB7_HRFIMS := StrTran(Time(),":","")
		VtAlert("Separacao Finalizada!!!","Aviso",.t.,2000,3)  
	Else
		CB7->CB7_STATPA := "1"
		VtAlert("Separacao em Pausa!!!","Aviso",.t.,3000,3)  
	EndIf
	CB7->(MsUnLock())

	//QUANDO FINALIZA ESTORNA A SDC, EFETUA A TRANSFERENCIA E GERA NOVA SDC
	If Empty(cMsgParcial) .Or. (CB7->CB7_STATUS == "9" .And. Empty(CB7->CB7__LCALI))
		VtClear()
		cNArmazem   := Space(2)
		cNovaLcz    := Space(15)
		@ 1,0 VTSay 'Informe Ender. Buffer'
		@ 2,0 VTSay 'Leia o endereco' //'Leia o endereco'
		@ 3,0 VTGet cNArmazem pict '@!' valid ! Empty(cNArmazem)
		@ 3,3 VTSay "-" VTGet cNovaLcz pict '@!' valid VtLastKey()==5 .or. VldNewEnd(cNArmazem,cNovaLcz)

		VTRead
		If VTLastkey() == 27
			Return .f.
		EndIf

		aItens		:= {}
		aLinha		:= {}
		cDocReq 	 := CriaVar('D3_DOC')
		aAdd(aItens,{cDocReq	,dDatabase})

		Begin Transaction
			VtClear()
			VtSay(2,0,"Aguarde Transferencia...") //"Aguarde..."

			For nx:=1 To Len(aSep)

				For ny:=1 To Len(aSep[nx,3])
					dbSelectArea("SD4")
					dbSetOrder(2)
					If dbSeek(xFilial()+aSep[nx,1]+aSep[nX,3,nY,3])

						dbSelectArea("SDC")
						dbSetOrder(2)
						dbSeek(xFilial()+SD4->D4_COD+cArmOri+SD4->D4_OP)
						cLote 		:= SDC->DC_LOTECTL
						nQuantDC 	:= SDC->DC_QUANT
						cLocalizDC	:= SDC->DC_LOCALIZ
						cTRT		:= SDC->DC_TRT

						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial()+SD4->D4_COD)

						If Rastro(SB1->B1_COD)
							SB8->(DbSetOrder(3))
							SB8->(DbSeek(xFilial("SB8")+SB1->B1_COD+cArmOri+cLote+""))
							dValid := SB8->B8_DTVALID
						EndIf

						dbSelectArea("SB2")
						dbSetOrder(1)
						dbSeek(xFilial()+SB1->B1_COD+"02")

						CONOUT(SB1->B1_COD+"-"+cArmOri+"-"+cLocalizDC+"- NOVO"+cNArmazem+"-"+cNovaLcz+" QUANT "+STRZERO(nQuantDC,10)+" SLD_SB2 "+STRZERO((B2_QATU-B2_QACLASS),10) )
						//FAZ A TRANSFERENCIA
						aLinha:={}
						AADD(aLinha,SB1->B1_COD)
						AADD(aLinha,SB1->B1_DESC)
						AADD(aLinha,SB1->B1_UM)
						AADD(aLinha,cArmOri)
						AADD(aLinha,cLocalizDC)
						AADD(aLinha,SB1->B1_COD)
						AADD(aLinha,SB1->B1_DESC)
						AADD(aLinha,SB1->B1_UM)
						AADD(aLinha,cNArmazem)
						AADD(aLinha,cNovaLcz)
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
						AADD(aLinha,'') 	//D3_ITEMGRD  
						AADD(aLinha,'') 	//D3_IDDCF    
						AADD(aLinha,'') 	//D3_OBSERVA  
						AADD(aLinha,'') 	//D3_OPTRANS  
						AADD(aLinha,'') 	//D3_NUM_PED  


						AADD(aItens,aLinha)			
						//ESTORNA A SDC
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza arquivo de empenhos               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						U_ACDGravaEmp(SD4->D4_COD,;
						cArmOri,;
						SD4->D4_QUANT,;
						SD4->D4_QTSEGUM,;
						SD4->D4_LOTECTL,;
						SD4->D4_NUMLOTE,;
						NIL,;
						NIL,;
						SD4->D4_OP,;
						SD4->D4_TRT,;
						NIL,;
						NIL,;
						"SC2",;
						SD4->D4_OPORIG,;
						SD4->D4_DATA,;
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
						IIF(cPaisLoc=="BRA",SD4->D4_CODLAN,NIL))


						If ! UsaCB0("01")
							CBLog("02",{SB1->B1_COD,nQuantDC,cLote,"",cArmOri,cLocalizDC,cNArmazem,cNovaLcz})
						EndIf
					Else
						VTALERT("Produto "+AllTrim(aSep[nX,3,nY,3])+" com empenho excluido, rotina cancelada","ERRO",.T.,4000,3)
						DisarmTransaction()
						Break
					EndIf
				Next
			Next

			If Len(aItens) > 0
				lMsErroAuto := .F.
				lMsHelpAuto := .T.
				aCols      := {}
				aHeader    := {}

				MSExecAuto({|x,y| MATA261(x,y)},aItens,3) //inclui

				If lMsErroAuto
					VTALERT("Falha na gravacao da transferencia","ERRO",.T.,4000,3) //###

					cNomArqErro := NomeAutoLog()
					conout(cNomArqErro)
					/*
					cNomNovArq  := __RELDIR+"ACDAT003.##R"
					If MsErase(cNomNovArq)
					__CopyFile(cNomArqErro,cNomNovArq)
					EndIf
					MsErase(cNomArqErro)
					*/
					DisarmTransaction()
					Break
				Else
					//FAZ A TRANFERENCIA E O NOVO EMPENHO
					For nx:=1 To Len(aSep)
						For ny:=1 To Len(aSep[nx,3])


							dbSelectArea("SD4")
							dbSetOrder(2)
							dbSeek(xFilial()+aSep[nx,1]+aSep[nX,3,nY,3])

							cLote 		:= aSep[nX,3,nY,9]
							nQuantDC 	:= SD4->D4_QTDEORI
							cLocalizDC	:= aSep[nX,3,nY,8]
							cTRT		:= SD4->D4_TRT

							//GERA A NOVA SDC
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza arquivo de empenhos               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							U_ACDGravaEmp(SD4->D4_COD,;
							SD4->D4_LOCAL,;
							nQuantDC,;
							SD4->D4_QTSEGUM,;
							cLote,;
							SD4->D4_NUMLOTE,;
							NIL,;
							NIL,;
							SD4->D4_OP,;
							cTRT,;
							NIL,;
							NIL,;
							"SC2",;
							SD4->D4_OPORIG,;
							SD4->D4_DATA,;
							@aTravas,;
							.F.,;		//CONTROLA INCLUSAO(.F.) OU ESTORNO(.T.)
							NIL,;
							NIL,;
							.F.,;		//GRAVA SD4
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							IIF(cPaisLoc=="BRA",SD4->D4_CODLAN,NIL))
						Next
					Next
				EndIf
			EndIf
			//GRAVA A NOVA LOCALIZACAO
			CB7->(DbSetOrder(1))
			CB7->(DbSeek(xFilial("CB7")+cOrdSep))
			RecLock("CB7",.f.)
			CB7->CB7__LCALI := cNovaLcz
			CB7->(MsUnLock())

		End Transaction
	EndIf



/*
If !VTYesNo("Gera as Ordens de Separacoes"#+cMsgParcial+"?","Aviso",.T.) //"Gera as Ordens de Separacoes"###"Aviso"
Return
EndIf
VTMsg("Aguarde...") //"Aguarde..."

If cOrigem == "1" // Pedido de Venda
GeraOSPV(aSep,cMsgParcial)
ElseIf cOrigem == "3" // Ordem de Producao
GeraOSOP(aSep,cMsgParcial)
EndIf
*/



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³  Estorna     ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³  Estorno da Separacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Estorna()
	Local aTela
	Local cEtiqEnd := Space(20)
	Local cProduto := Space(48)
	Local cVolume  := Space(10)
	Local nQtde    := 1
	Private cArmazem := Space(02)
	Private cEndereco:= Space(15)
	Private cLoteNew:= Space(10)
	Private cSLoteNew:=Space(6)

	aTela := VTSave()
	VTClear()
	@ 0,0 VtSay "Estorno da leitura" //"Estorno da leitura"
	@ 1,0 VTSay 'Leia o endereco' //'Leia o endereco'
	If UsaCB0('02')
		@ 2,0 VTGet cEtiqEnd pict '@!' valid VldEndEst(@cArmazem,@cEndereco,cEtiqEnd)
	Else
		@ 2,0 VTGet cArmazem pict '@!' valid ! Empty(cArmazem)
		@ 2,3 VTSay "-" VTGet cEndereco pict '@!' valid VtLastKey()==5 .or. VldEndEst(@cArmazem,@cEndereco)
	EndIf
	cProduto   := Space(48)
	If ! UsaCB0('01')
		@ 5,0 VTSay 'Qtde ' VtGet nQtde pict cPictQtde valid nQtde > 0 when VtLastkey()==5  //'Qtde '
	EndIf
	@ 6,0 VTSay 'Leia o produto' //'Leia o produto'
	@ 7,0 VTGet cProduto pict '@!' VALID VTLastkey() == 5 .or. VldProdEst(cProduto,@nQtde,cArmazem,cEndereco,cVolume)
	VTRead
	VTRestore(,,,,aTela)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldEndEst ³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao do Endereco na rotina de estorno                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEndEst(cArmazem,cEndereco,cEtiqEnd)
	Local aRet
	Local lAchou
	VtClearBuffer()
	If Empty(cArmazem) // se Empty(cArmazem) entao e' etiqueta de endereco com CB0
		aRet := CBRetEti(cEtiqEnd,'02')
		If len(aRet) == 0
			VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cArmazem  := aRet[2]
		cEndereco := aRet[1]
	EndIf
	CB9->(DbSetOrder(1))
	If ! CB9->(DbSeek(xFilial("CB9")+CB7->CB7_ORDSEP))
		VtAlert("Nao existe itens separados para esta Ordem de Separacao","Aviso",.t.,4000,3)  //"Nao existe itens separados para esta Ordem de Separacao"###"Aviso"
		VTClearGet("cArmazem")
		VTClearGet("cEndereco")
		VTGetSetFocus("cArmazem")
		VtKeyboard(Chr(20))  // zera o get
		Return
	EndIf
	lAchou := .f.
	While CB9->(! Eof() .and. xFilial("CB9")+CB7->CB7_ORDSEP==CB9_FILIAL+CB9_ORDSEP)
		If cArmazem+cEndereco == CB9->(CB9_LOCAL+CB9_LCALIZ)
			lAchou:= .t.
			Exit
		EndIf
		CB9->(DBSkip())
	EndDo
	If ! lAchou
		VtAlert("Endereco incorreto","Aviso",.t.,4000,3)  //"Endereco incorreto"###"Aviso"
		cArmazem  := Space(02)
		cEndereco := Space(15)
		VTClearGet("cArmazem")
		VTClearGet("cEndereco")
		VTGetSetFocus("cArmazem")
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProdEst³ Autor ³ ACD                   ³ Data ³ 14/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao do produto na rotina de estorno                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function VldProdEst(cEProduto,nQtde,cArmazem,cEndereco,cVolume)
	Local cTipo
	Local aEtiqueta,aRet
	Local cLote  := Space(10)
	Local cSLote := Space(6)
	Local cNumSer:= Space(20)
	Local cSeek  := ""
	Local	nQtdItens:= 0
	Local nQE:=0
	Local nPos
	Local cProduto
	Local nTQtde   := 0
	Local nQtdSaldo:= 0
	Local nSaldoCB9:= 0
	Local nQeDisp  := 0
	Local nY,nW
	Local aItensE :={}
	Local aItensE2:={}
	Private nQtdLida :=0

	If Empty(cEProduto)
		Return .f.
	EndIf
	If !CBLoad128(@cEProduto)
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	cTipo := CBRetTipo(cEProduto)
	If cTipo == "01"
		aEtiqueta:= CBRetEti(cEProduto,"01")
		If Empty(aEtiqueta)
			VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		CB9->(DbSetorder(1))
		If ! CB9->(DbSeek(xFilial("CB9")+cOrdSep+Left(cEProduto,10)))
			VtAlert("Produto nao separado","Aviso",.t.,4000,3)  //"Produto nao separado"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cProduto := aEtiqueta[1]
		nQE      := aEtiqueta[2]
		cLote    := aEtiqueta[16]
		cSLote   := aEtiqueta[17]
		nQtdLida := nQE
		If cArmazem+cEndereco <> CB0->(CB0_LOCAL+CB0_LOCALIZ)
			VtAlert("Produto nao pertence a este endereco, o correto eh, "+CB0->CB0_LOCAL+"-"+CB0->CB0_LOCALIZ,"Aviso",.t.,5000,3)  //"Produto nao pertence a este endereco, o correto eh, "###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cLoteNew:= cLote
		cSLoteNew:=cSLote
	ElseIf cTipo $ "EAN8OU13-EAN14-EAN128"
		aRet:= CBRetEtiEan(cEProduto)
		If len(aRet) == 0
			VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cProduto := aRet[1]
		nQE  :=CBQtdEmb(aRet[1])*nQtde
		If Empty(nQE)
			VtAlert("Quantidade invalida","Aviso",.t.,4000,3)  //"Quantidade invalida"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		cLote := aRet[3]
		If ! CBRastro(aRet[1],aItens[_POSLOTECTL],@cSLote)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cNumSer:= aRet[5]	 // Numero de Serie
		If Empty(cNumSer) .and. CBSeekNumSer(cOrdSep,cProduto,nQtde)
			If ! VldQtde(nQtde,.T.)
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			EndIf
			If ! CBNumSer(@cNumSer)
				VTKeyBoard(chr(20))
				Return .f.
			EndIf
		Endif

		CB9->(DBSetOrder(9))
		If ! CB9->(DbSeek(xFilial("CB9")+cOrdSep+cProduto+cArmazem+cEndereco+cLote+cSLote+cNumSer))
			VtAlert("Item nao encontrado","Aviso",.t.,4000,3)  //"Item nao encontrado"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
		nQeDisp:= CB9->(RetQeDisp(CB9_PROD,CB9_LOCAL,CB9_LCALIZ,CB9_LOTECT,CB9_NUMLOT))
		If nQE > nQeDisp
			VtAlert("Quantidade informada maior do que separada","Aviso",.t.,4000,3)  //"Quantidade informada maior do que separada"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
	Else
		VtAlert("Etiqueta invalida","Aviso",.t.,4000,3)  //"Etiqueta invalida"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	IF ! VtYesNo("Confirma o estorno?","Aviso",.t.)  //"Confirma o estorno?"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	nQtdLida := nQE

	// montando array
	CB8->(DbSetOrder(3))
	CB8->(DbSeek(xFilial("CB8")+cOrdSep))
	While ! CB8->(Eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == cOrdSep
		If CB8->(CB8_LOCAL+CB8_LCALIZ) # cArmazem+cEndereco
			CB8->(DbSkip())
			Loop
		EndIf
		If CB8->CB8_PROD # cProduto
			CB8->(DbSkip())
			Loop
		EndIf
		If CB8->CB8_QTDORI == CB8->CB8_SALDOS // Nao tem quantidade para estornar neste registro
			CB8->(DbSkip())
			Loop
		EndIf
		nPos := Ascan(aItensE,{|x| x[2]+x[3]+x[4]+x[5]+x[8]+x[9]+x[10]+x[13] == CB8->(CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8->CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER+CB8_CFLOTE)})
		If  nPos == 0
			aadd(aItensE,{{CB8->(Recno())},;
			CB8->CB8_ITEM,;
			CB8->CB8_PROD,;
			CB8->CB8_LOCAL,;
			CB8->CB8_LCALIZ,;
			CB8->CB8_SALDOS,;
			CB8->CB8_QTDORI,;
			CB8->CB8_LOTECT,;
			CB8->CB8_NUMLOT,;
			CB8->CB8_NUMSER,;
			NIL,;
			NIL,;
			CB8->CB8_CFLOTE })
		Else
			If Ascan(aItensE[nPos,1],{|x| x == CB8->(Recno())}) == 0
				aadd(aItensE[nPos,1],CB8->(Recno()))
			EndIf
			aItensE[nPos,6]+= CB8->CB8_SALDOS
			aItensE[nPos,7]+= CB8->CB8_QTDORI
		EndIf
		CB8->(DbSkip())
	EndDo

	aItensE := aSort(aItensE,,,{|x,y| x[4]+x[5]+x[8]+x[9]+x[10] < y[4]+y[5]+y[8]+y[9]+y[10]})

	cIdCB0  := CB9->CB9_CODETI

	cLoteNew:= cLote
	cSLoteNew:=cSLote

	aItensE2 := aClone(aItensE)
	nQtdItens:= Len(aItensE2)

	For nY:= 1 to nQtdItens
		nPos:= ascan(aItensE2,{|x| X[_POSARMAZEM]+X[_POSENDERECO]+X[_POSLOTECTL]+X[_POSNUMLOTE]+X[_POSNUMSERIE] == ;
		CB9->(CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSUG+CB9_NUMSER)})
		If nPos == 0
			Loop
		EndIf
		For nW:= 1 to Len(aItensE2[nPos,_POSRECNO])
			CB8->(DbGoto(aItensE2[nPos,_POSRECNO,nW]))
			If UsaCB0("01")
				cSeek:= CB8->CB8_ORDSEP+cIdCB0
				CB9->(DbSetOrder(1))
				CB9->(DbSeek(xFilial("CB9")+cSeek))
			Else
				cSeek:= CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+cLoteNew+cSLoteNew+CB8_NUMSER+CB8_LOTECT+CB8_NUMLOT)+Space(10)+cIdCB0
				CB9->(DbSetOrder(10))
				CB9->(DbSeek(xFilial("CB9")+cSeek))
			EndIf
			If CB9->(Eof())
				Loop
			EndIf
			nSaldoCB9:= CB9->CB9_QTESEP
			RecLock("CB9",.F.)
			CB9->CB9_QTESEP -= If(nQtdLida > nSaldoCB9,nSaldoCB9,nQtdLida)
			If Empty(CB9->CB9_QTESEP)
				CB9->(DbDelete())
			EndIf
			CB9->(MsUnlock())
			RecLock("CB8")
			CB8->CB8_SALDOS +=  If(nQtdLida > nSaldoCB9,nSaldoCB9,nQtdLida)
			CB8->(MsUnlock())
			aItensE2[nPos,_POSSLDSEP] += If(nQtdLida > nSaldoCB9,nSaldoCB9,nQtdLida)
			nQtdLida -= If(nQtdLida > nSaldoCB9,nSaldoCB9,nQtdLida)
			If nQtdLida == 0
				Exit
			Endif
		Next
		If nQtdLida == 0
			Exit
		EndIf
		If aItensE2[nPos,6] == aItensE2[nPos,7] // Nao ha mais quantidade para ser estornada deste item
			aDel(aItensE2,nPos)
			aSize(aItensE2,Len(aItensE2)-1)
		EndIf
	Next
	RecLock("CB7",.F.)
	CB7->CB7_STATUS := '1'
	CB7->(MsUnlock())
	nQtde:= 1
	VTGetRefresh('nQtde')
	VtKeyboard(Chr(20))  // zera o get
Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³RetQeDisp ³ Autor ³ ACD                   ³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Retorna a quantidade disponivel do produto para o estorno   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetQeDisp(cProduto,cLocal,cEndereco,cLote,cSubLote)
	Local nQuant  := 0
	Local aAreaCB9:= GetArea("CB9")
	Local nRecCB9 := CB9->(Recno())

	CB9->(DbSetOrder(9))
	CB9->(DbSeek(xFilial("CB9")+cOrdSep+cProduto))
	While CB9->(! Eof() .and. CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT == xFilial("CB9")+cOrdSep+cProduto+cLocal+cEndereco+cLote+cSubLote)
		nQuant+= CB9->CB9_QTESEP
		CB9->(DbSkip())
	EndDo

	RestArea(aAreaCB9)
	CB9->(DbGoTo(nRecCB9))
Return(nQuant)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GeraNewEti ³ Autor ³ Anderson Rodrigues  ³ Data ³ 15/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Nova etiqueta para produtos de quantidade variavel    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SigaACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraNewEti(nQtd)
	Local cEtiqueta:= CBProxCod("MV_CODCB0")
	Local nRecno
	Local nRecnoCB0 := CB0->(Recno())

	If ! CB5SetImp(CBRLocImp("MV_IACD01"),IsTelNet())
		VTBeep(3)
		VTAlert('Local de impressao nao configurado, MV_IACD01','Aviso',.t.,3000)  //'Local de impressao nao configurado, MV_IACD01'###'Aviso'
		Return
	EndIf

	VTMsg("Imprimindo...")  //"Imprimindo..."

	CB0->(DbGoto(nRecnoCB0))
	nRecno:= CB0->(CBCopyRec())
	CB0->(DbGoto(nRecno))
	Reclock("CB0",.f.)
	CB0->CB0_QTDE   := nQtd
	CB0->CB0_CODETI := cEtiqueta
	CB0->CB0_ORIGEM := "CB7"
	CB0->(MSUnlock())

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
	If ExistBlock('IMG01')
		ExecBlock("IMG01",,,{,,CB0->CB0_CODETI})
	EndIf
	If ExistBlock('IMG00')
		ExecBlock("IMG00",,,{"T_ACDV170",cOrdSep})
	EndIf
	MSCBCLOSEPRINTER()
	CB0->(DbGoto(nRecnoCB0))
	Reclock("CB0",.f.)
	CB0->CB0_QTDE := CB0->CB0_QTDE - nQtd
	CB0->(MSUnlock())
Return(cEtiqueta)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³  VldQtde ³ Autor ³ Anderson Rodrigues    ³ Data ³ 29/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da quantidade informada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldQtde(nQtde,lSerie)
	Default lSerie:= .f.

	If nQtde <= 0
		Return .f.
	EndIf
	If lSerie .and. nQtde > 1
		VTAlert("Quantidade invalida !!!","Aviso",.T.,2000) //"Quantidade invalida !!!"###"Aviso"
		VTAlert("Quando se utiliza numero de serie a quantidade deve ser == 1","Aviso",.T.,4000) //"Quando se utiliza numero de serie a quantidade deve ser == 1"###"Aviso"
		Return .f.
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD002    ºAutor  ³Microsiga           º Data ³  08/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldNewEnd(cNArmazem,cNEndereco)
	VTClearBuffer()
	If Empty(cNEndereco)
		VtKeyBoard(chr(23))
		Return .f.
	EndIf
	/*
	//QUANDO NAO FOR ENDERECO PORTA PALLET
	If Left(cNEndereco,3) # "BUF"
	//VERIFICA SE EXISTE MAIS DE 2 PRODUTOS NOS CARRINHOS
	cQuery := " SELECT BF_PRODUTO FROM "+RetSqlName("SBF")
	cQuery += " WHERE BF_LOCALIZ = '"+cNEndereco+"'  AND D_E_L_E_T_ <> '*' "
	cQuery += " AND BF_FILIAL = '"+cFilAnt+"' AND BF_QUANT > 0"

	MEMOWRITE("WACD003.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nRec

	If nRec > 0
	VTBEEP(2)
	VTALERT("Não é permitido mais que duas OPs por endereço!","AVISO",.T.,4000)
	VTClearGet()
	VTClearGet("cNArmazem")
	VTGetSetFocus("cNArmazem")
	TRB->(dbcloseArea())
	Return .f.
	EndIf
	TRB->(dbcloseArea())
	EndIf
	*/
	SBE->(DbSetOrder(1))
	If ! SBE->(DbSeek(xFilial()+cNArmazem+cNEndereco))
		VTBEEP(2)
		VTALERT("Endereco nao encontrado","AVISO",.T.,4000)    //"Endereco nao encontrado"###"AVISO"
		VTClearGet()
		VTClearGet("cNArmazem")
		VTGetSetFocus("cNArmazem")
		Return .f.
	Else
		VTALERT("Novo Endereco OK","AVISO",.T.,2000)    //"Endereco nao encontrado"###"AVISO"
	EndIf



Return
