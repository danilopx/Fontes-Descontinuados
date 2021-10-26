#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//---------------------------------------------------------------------------------------------------------------------------
// Programa: TFESTR02 																					Autor: C. Torres        Data: 31/08/2011 
// Descricao: Mapa de movimentação diaria por produto ocorrida nos armazens
//---------------------------------------------------------------------------------------------------------------------------
User Function TFESTR02()

	Private cAliasTrb	:= "TMPES02" // GetNextAlias()
	Private cPerg     := 'TFESTR02'
	Private cString	:= 'Query'
	Private oReport

// AjustaSx1( cPerg ) // Chama funcao de pergunta
	If SM0->M0_CODIGO $ '01x02'
		If pergunte(cPerg,.T.)

			Processa( {|lEnd| U_ESTTExcel1(@lEnd) } ,  'Mapa de movimentação' , 'Aguarde, preparando planilha...' , .T. )

		EndIf
	Else
		Aviso("Modulo não disponivel", "Modulo não disponivel para a empresa selecionada.", {"Ok"}, 3)
	EndIF
Return


//--------------------------------------------------------------------------------------------------------------
// Função: TExcel1 - Exportação para Excel
//--------------------------------------------------------------------------------------------------------------
User Function ESTTExcel1(lEnd)

	Local __aHeader	:= {}
	Local __aCols		:= {}
	Local aSalAtu		:= { 0,0,0,0,0,0,0 }
	Local _nQT_SALDOINI
	//Local __cChave
	Local _cVariavel
	Local _mCabcSD3	:= {}
	Local	__lInterrompido := .F.

	Local _nQTFinal	:= 0
	Local _nVlCusto	:= 0
	Local	_cIdProduto	:= ""
	Local	_cIdLocal 	:= ""
	Local	_cNmProduto	:= ""
	Local	_cTpProduto	:= ""

	Local	_nQTFinDE	:= 0
	Local	_nVlCusDE	:= 0
	Local	_nQTFinEM	:= 0
	Local	_nVlCusEM	:= 0

	Local aEstrutura 	:= {{'ID_CHAVE','C',12,0},{'SLD_INI','N',10,0},{'QT_MOVTO','N',10,0},{'VL_CUSTO','N',12,2},{'CD_PRODT','C',09,0},{'IMPRESS','C',01,0},{'B6_TIPO','C',01,0},{'NM_ARMAZ','C',50,0},{'NM_PRODT','C',50,0},{'ID_LOCAL','C',02,0},{'B1_TIPO','C',02,0}}
	Local cDirDocs		:= MsDocPath()
	Local cArquivo		:= CriaTrab(,.F.)
	Local cAliasQry	:= GetNextAlias()
	Local cTerChave	:= ""
	Local __nLoop := 0

//
// Cria tabela temporaria que recebe movimentos gerados pela procedure
//
	DbCreate(cDirDocs+"\"+cArquivo,aEstrutura)
	DbUseArea(.T.,"dbfcdx",cDirDocs+"\"+cArquivo,(cAliasQry),.F.,.F.)
	DbCreateIndex(cDirDocs+"\"+cArquivo+".cdx","ID_CHAVE",{ || ID_CHAVE },.F.)

	If TCSPExist("SP_REL_MOVIMENTO_DIARIO")

		U_TFterceiros( cAliasQry )

		If SM0->M0_CODIGO='01'

			_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"', '" + Alltrim(Str(mv_par07)) + "'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
		EndIf
		If SM0->M0_CODIGO='02'

			mv_par07 := 3

			_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO_MERCABEL '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
		EndIf

		If Select( (cAliasTrb) ) > 0
			dbSelectArea( (cAliasTrb) )
			DbCloseArea()
		EndIf

		TCQUERY _cQuery NEW ALIAS "TMPES02"

		//TCSetField("TMPCM01","C1_DATPRF"	,"D") 	// Dt. necessidade

	EndIf
	dbSelectArea( (cAliasTrb) )

	ProcRegua( (cAliasTrb)->(reccount()) )


	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf

	aTam := TamSX3('D1_COD'			); Aadd(__aHeader, {'Produto'			, 'ID_PRODUTO'	, PesqPict('SD1', 'D1_COD'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''})
	aTam := TamSX3('B1_DESC'		); Aadd(__aHeader, {'Descricao'		, 'NM_PRODUTO'	, PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''})
	aTam := TamSX3('B1_TIPO'		); Aadd(__aHeader, {'Tipo'				, 'B1_TIPO'		, PesqPict('SB1', 'B1_TIPO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''})
	aTam := TamSX3('D1_LOCAL'		); Aadd(__aHeader, {'Armazen'			, 'ID_LOCAL'	, PesqPict('SD1', 'D1_LOCAL'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''})
	aTam := TamSX3('BE_LOCALIZ'	); Aadd(__aHeader, {'Nome Armazen'	, 'NM_ARMAZ'	, PesqPict('SBE', 'BE_LOCALIZ', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''})

	aTam := TamSX3('B2_QATU'		); Aadd(__aHeader, {'Saldo Inicial'	, 'QT_SALDOINI', PesqPict('SB2', 'B2_QATU'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})

	ZAJ->(DbSetOrder(1))
	ZAJ->(DbGoTop())
	While !ZAJ->(Eof())
		aTam := TamSX3('B2_QATU'		); Aadd(__aHeader, { Alltrim(ZAJ->ZAJ_DESCR)	, '_nQT'+Alltrim(ZAJ->ZAJ_TIPO)+StrZero(Val(ZAJ->ZAJ_COD),3), PesqPict('SB2', 'B2_QATU'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
		ZAJ->(DbSkip())
	End

	If SM0->M0_CODIGO $ '02'
		//
		// Este procedimento foi adotado para atender necessidade do Douglas, porque os "Tipos de Movimentos" entre MERCABEL e DAIHATSU sao distintos.
		//
		If EmpOpenFile("SF5","SF5",1,.T.,"01","C")
			SF5->(DbSetOrder(1))
			SF5->(DbGoTop())
			While !SF5->(Eof())
				aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { Alltrim(SF5->F5_TEXTO)	, '_nQTx'+Alltrim(SF5->F5_CODIGO), PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
				Aadd( _mCabcSD3 , '_nQTx'+Alltrim(SF5->F5_CODIGO) )
				SF5->(DbSkip())
			End
			EmpOpenFile("SF5","SF5",1,.T.,"02","C")
		EndIf
		SF5->(DbSetOrder(1))
		SF5->(DbGoTop())
		While !SF5->(Eof())
			aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { Alltrim(SF5->F5_TEXTO)	, '_nQT3'+Alltrim(SF5->F5_CODIGO), PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
			Aadd( _mCabcSD3 , '_nQT3'+Alltrim(SF5->F5_CODIGO) )
			SF5->(DbSkip())
		End
	Else
		SF5->(DbSetOrder(1))
		SF5->(DbGoTop())
		While !SF5->(Eof())
			aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { Alltrim(SF5->F5_TEXTO)	, '_nQT3'+Alltrim(SF5->F5_CODIGO), PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
			Aadd( _mCabcSD3 , '_nQT3'+Alltrim(SF5->F5_CODIGO) )
			SF5->(DbSkip())
		End
		//
		// Este procedimento foi adotado para atender necessidade do Douglas, porque os "Tipos de Movimentos" entre MERCABEL e DAIHATSU sao distintos.
		//
		If EmpOpenFile("SF5","SF5",1,.T.,"02","C")
			SF5->(DbSetOrder(1))
			SF5->(DbGoTop())
			While !SF5->(Eof())
				aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { Alltrim(SF5->F5_TEXTO)	, '_nQTx'+Alltrim(SF5->F5_CODIGO), PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
				Aadd( _mCabcSD3 , '_nQTx'+Alltrim(SF5->F5_CODIGO) )
				SF5->(DbSkip())
			End
			EmpOpenFile("SF5","SF5",1,.T.,"01","C")
		EndIf
	EndIf

	aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { 'Transferencia - Entrada'	, '_nQT3499', PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
	aTam := TamSX3('D3_QUANT'		); Aadd(__aHeader, { 'Transferencia - Saida'		, '_nQT3999', PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})

	aTam := TamSX3('B2_QATU'		); Aadd(__aHeader, {'Saldo Final'	, '_nQTFinal', PesqPict('SB2', 'B2_QATU'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
	aTam := TamSX3('B2_VATU1'		); Aadd(__aHeader, {'Custo'			, '_nVlCusto', PesqPict('SB2', 'B2_VATU1'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})

	aTam := TamSX3('B2_QATU'		); Aadd(__aHeader, {'Saldo Em 3os'	, '_nQTFinEM', PesqPict('SB2', 'B2_QATU'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
	aTam := TamSX3('B2_VATU1'		); Aadd(__aHeader, {'Custo Em 3os'	, '_nVlCusEM', PesqPict('SB2', 'B2_VATU1'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
	aTam := TamSX3('B2_QATU'		); Aadd(__aHeader, {'Saldo De 3os'	, '_nQTFinDE', PesqPict('SB2', 'B2_QATU'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})
	aTam := TamSX3('B2_VATU1'		); Aadd(__aHeader, {'Custo De 3os'	, '_nVlCusDE', PesqPict('SB2', 'B2_VATU1'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})

	aTam := TamSX3('B1_DESC'		); Aadd(__aHeader, {'Empresa'			, '_cEmpresa', PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''})

	_cEmpresa := Alltrim(SM0->M0_NOME) + "-" + SM0->M0_FILIAL

	While !(cAliasTrb)->(Eof()) .AND. !__lInterrompido


		If mv_par07 = 2 // Saldo com base na função Calcest padrao do PROTHEUS
			aSalAtu			:= CalcEst(	(cAliasTrb)->ID_PRODUTO , (cAliasTrb)->ID_LOCAL , mv_par02 + 1,,, .F. )
			_nQTFinal		:= aSalAtu[1]

			_nVlCusto		:= _nQTFinal * (cAliasTrb)->VL_CUSTO

			aSalAtu			:= { 0,0,0,0,0,0,0 }
			aSalAtu			:= CalcEst(	(cAliasTrb)->ID_PRODUTO , (cAliasTrb)->ID_LOCAL , mv_par01 - 1 ,,, .F. )
			_nQT_SALDOINI	:= aSalAtu[1]
			_nTT_Geral 		:= _nQTFinal
			_nTT_Geral 		+= _nQT_SALDOINI
		Else
			_nQT_SALDOINI	:= 0
			_nQTFinal		:= 0
			_nTT_Geral		:= 1
		EndIf

		cTerChave := (cAliasTrb)->ID_PRODUTO + (cAliasTrb)->ID_LOCAL + "D"
		If (cAliasQry)->(DbSeek( cTerChave ))
			_nQTFinDE	:= (cAliasQry)->SLD_INI + (cAliasQry)->QT_MOVTO
			_nVlCusDE	:= (cAliasQry)->VL_CUSTO * _nQTFinDE

			RecLock((cAliasQry),.F.)
			(cAliasQry)->IMPRESS	:= "S"
			(cAliasQry)->(MsUnlock())

		Else
			_nQTFinDE	:= 0
			_nVlCusDE	:= 0
		EndIf

		cTerChave := (cAliasTrb)->ID_PRODUTO + (cAliasTrb)->ID_LOCAL + "E"
		If (cAliasQry)->(DbSeek( cTerChave ))
			_nQTFinEM	:= (cAliasQry)->SLD_INI + (cAliasQry)->QT_MOVTO
			_nVlCusEM	:= (cAliasQry)->VL_CUSTO * _nQTFinEM

			RecLock((cAliasQry),.F.)
			(cAliasQry)->IMPRESS	:= "S"
			(cAliasQry)->(MsUnlock())

		Else
			_nQTFinEM	:= 0
			_nVlCusEM	:= 0
		EndIf

		_cIdProduto		:= (cAliasTrb)->ID_PRODUTO
		_cIdLocal 		:= (cAliasTrb)->ID_LOCAL
		_cNmProduto		:= (cAliasTrb)->NM_PRODUTO
		_cTpProduto		:= (cAliasTrb)->B1_TIPO
		_cNmLocal 		:= (cAliasTrb)->NM_ARMAZ

		_nQT3499			:= 0
		_nQT3999			:= 0

		ZAJ->(DbGoTop())
		While !ZAJ->(Eof())
			If ZAJ->ZAJ_TIPO $ 'ExS'
				_cVariavel := '_nQT' + Alltrim(ZAJ->ZAJ_TIPO) + StrZero(Val(ZAJ->ZAJ_COD),3)
				&_cVariavel := 0
			EndIf
			ZAJ->(DbSkip())
		End

		For __nLoop := 1 to Len(_mCabcSD3)
			_cVariavel 	:= _mCabcSD3[ __nLoop ]
			&_cVariavel := 0
		Next


		While !(cAliasTrb)->(Eof()) .and. (cAliasTrb)->ID_PRODUTO + (cAliasTrb)->ID_LOCAL = _cIdProduto + _cIdLocal
			IncProc()
			If lEnd
				MsgInfo(cCancela,"Fim")
				__lInterrompido := .T.
				Exit
			Endif

			If Empty( (cAliasTrb)->ZAJ_COD ) .and. (cAliasTrb)->ZAJ_TIPO = "I" .and. mv_par07 != 2
				_nTT_Geral		+= (cAliasTrb)->TT_QUANT
				_nQT_SALDOINI	:= (cAliasTrb)->TT_QUANT
				_nQTFinal 		+= (cAliasTrb)->TT_QUANT
				_nVlCusto		:= (cAliasTrb)->VL_CUSTO

			ElseIf !Empty( (cAliasTrb)->ZAJ_COD ) .and. (cAliasTrb)->ZAJ_TIPO != "X"
				_cVariavel 	:= "_nQT" + Alltrim((cAliasTrb)->ZAJ_TIPO) + (cAliasTrb)->ZAJ_COD
				&_cVariavel += (cAliasTrb)->TT_QUANT
				_nTT_Geral 	+= (cAliasTrb)->TT_QUANT
				_nVlCusto	:= (cAliasTrb)->VL_CUSTO
				If mv_par07 != 2	// NAO aplicar quando o Saldo for calculado com base na função Calcest do PROTHEUS
					_nQTFinal	+= (cAliasTrb)->TT_QUANT
				EndIf

			ElseIf !Empty( (cAliasTrb)->ZAJ_COD ) .and. (cAliasTrb)->ZAJ_TIPO = "X"
				//_cVariavel 	:= "_nQT3" + Alltrim( (cAliasTrb)->ZAJ_COD )

				If Ascan( _mCabcSD3 , "_nQT3" + Alltrim( (cAliasTrb)->ZAJ_COD ) ) > 0
					_cVariavel 	:= _mCabcSD3[  Ascan( _mCabcSD3 , "_nQT3" + Alltrim( (cAliasTrb)->ZAJ_COD ) )  ]
					&_cVariavel += (cAliasTrb)->TT_QUANT
					_nTT_Geral 	+= (cAliasTrb)->TT_QUANT
					_nVlCusto	:= (cAliasTrb)->VL_CUSTO
					If mv_par07 != 2	// NAO aplicar quando o Saldo for calculado com base na função Calcest do PROTHEUS
						_nQTFinal	+= (cAliasTrb)->TT_QUANT
					EndIf

				ElseIf (cAliasTrb)->ZAJ_COD $ "499x999"
					_cVariavel 	:= "_nQT3" + Alltrim( (cAliasTrb)->ZAJ_COD )
					&_cVariavel += (cAliasTrb)->TT_QUANT
					_nTT_Geral 	+= (cAliasTrb)->TT_QUANT
					_nVlCusto	:= (cAliasTrb)->VL_CUSTO
					If mv_par07 != 2	// NAO aplicar quando o Saldo for calculado com base na função Calcest do PROTHEUS
						_nQTFinal	+= (cAliasTrb)->TT_QUANT
					EndIf
				EndIf

			EndIf
			(cAliasTrb)->(dbSkip())
		End

		If _nTT_Geral != 0  .or.  _nQTFinEM != 0  .or.  _nQTFinDE != 0

			_nVlCusto	:= _nQTFinal * _nVlCusto

			For __nLoop := 1 to Len(_mCabcSD3)
				_cVariavel 	:= "__cVar" + StrZero( __nLoop , 2)
				&_cVariavel := _mCabcSD3[ __nLoop ]
			Next

			If SM0->M0_CODIGO $ '01x02'
				AAdd(  __aCols , { ;
					_cIdProduto					,;
					_cNmProduto					,;
					_cTpProduto					,;
					_cIdLocal					,;
					_cNmLocal					,;
					_nQT_SALDOINI				,;
					_nQTS001						,;
					_nQTS002						,;
					_nQTS003						,;
					_nQTS004						,;
					_nQTS005						,;
					_nQTE006						,;
					_nQTE007						,;
					_nQTE008						,;
					_nQTE009						,;
					_nQTE010						,;
					_nQTS011						,;
					&__cVar01					,;
					&__cVar02					,;
					&__cVar03					,;
					&__cVar04					,;
					&__cVar05					,;
					&__cVar06					,;
					&__cVar07					,;
					&__cVar08					,;
					&__cVar09					,;
					&__cVar10					,;
					&__cVar11					,;
					&__cVar12					,;
					&__cVar13					,;
					&__cVar14					,;
					&__cVar15					,;
					&__cVar16					,;
					&__cVar17					,;
					&__cVar18					,;
					&__cVar19					,;
					&__cVar20					,;
					&__cVar21					,;
					&__cVar22					,;
					&__cVar23					,;
					&__cVar24					,;
					_nQT3499 					,;
					_nQT3999						,;
					_nQTFinal					,;
					_nVlCusto					,;
					_nQTFinEM					,;
					_nVlCusEM					,;
					_nQTFinDE					,;
					_nVlCusDE					,;
					_cEmpresa					,;
					.F.})

			EndIf
		EndIf

	End

	(cAliasQry)->(DbGoTop())

	While !(cAliasQry)->(Eof()) .AND. !__lInterrompido

		If (cAliasQry)->IMPRESS != "S"

			_nQTFinDE	:= 0
			_nVlCusDE	:= 0
			_nQTFinEM	:= 0
			_nVlCusEM	:= 0

			If (cAliasQry)->B6_TIPO = "D"
				_nQTFinDE	:= (cAliasQry)->SLD_INI + (cAliasQry)->QT_MOVTO
				_nVlCusDE	:= (cAliasQry)->VL_CUSTO * _nQTFinDE
			ElseIf (cAliasQry)->B6_TIPO = "E"
				_nQTFinEM	:= (cAliasQry)->SLD_INI + (cAliasQry)->QT_MOVTO
				_nVlCusEM	:= (cAliasQry)->VL_CUSTO * _nQTFinEM
			EndIf

			_cIdProduto		:= (cAliasQry)->CD_PRODT
			_cIdLocal 		:= (cAliasQry)->ID_LOCAL
			_cNmProduto		:= (cAliasQry)->NM_PRODT
			_cTpProduto		:= (cAliasQry)->B1_TIPO
			_cNmLocal 		:= (cAliasQry)->NM_ARMAZ

			_nQT3499			:= 0
			_nQT3999			:= 0
			_nQT_SALDOINI	:= 0
			_nQTFinal 		:= 0
			_nVlCusto		:= 0

			ZAJ->(DbGoTop())
			While !ZAJ->(Eof())
				If ZAJ->ZAJ_TIPO $ 'ExS'
					_cVariavel := '_nQT' + Alltrim(ZAJ->ZAJ_TIPO) + StrZero(Val(ZAJ->ZAJ_COD),3)
					&_cVariavel := 0
				EndIf
				ZAJ->(DbSkip())
			End

			For __nLoop := 1 to Len(_mCabcSD3)
				_cVariavel 	:= _mCabcSD3[ __nLoop ]
				&_cVariavel := 0
			Next

			If SM0->M0_CODIGO $ '01x02'
				AAdd(  __aCols , { ;
					_cIdProduto					,;
					_cNmProduto					,;
					_cTpProduto					,;
					_cIdLocal					,;
					_cNmLocal					,;
					_nQT_SALDOINI				,;
					_nQTS001						,;
					_nQTS002						,;
					_nQTS003						,;
					_nQTS004						,;
					_nQTS005						,;
					_nQTE006						,;
					_nQTE007						,;
					_nQTE008						,;
					_nQTE009						,;
					_nQTE010						,;
					_nQTS011						,;
					&__cVar01					,;
					&__cVar02					,;
					&__cVar03					,;
					&__cVar04					,;
					&__cVar05					,;
					&__cVar06					,;
					&__cVar07					,;
					&__cVar08					,;
					&__cVar09					,;
					&__cVar10					,;
					&__cVar11					,;
					&__cVar12					,;
					&__cVar13					,;
					&__cVar14					,;
					&__cVar15					,;
					&__cVar16					,;
					&__cVar17					,;
					&__cVar18					,;
					&__cVar19					,;
					&__cVar20					,;
					_nQT3499 					,;
					_nQT3999						,;
					_nQTFinal					,;
					_nVlCusto					,;
					_nQTFinEM					,;
					_nVlCusEM					,;
					_nQTFinDE					,;
					_nVlCusDE					,;
					_cEmpresa					,;
					.F.})

			EndIf
		EndIf
		(cAliasQry)->(DbSkip())
	End

	If len( __aCols ) > 0 .AND. .NOT. lEnd
		DlgToExcel({ {"GETDADOS", "Movimentação de Armazens em "+Dtoc(mv_par01) + " a "+Dtoc(mv_par02), __aHeader, __aCols} })
	ElseIf .NOT. lEnd
		MsgAlert("Não há dados a exportar para o Excel!","")
	EndIf

Return

//--------------------------------------------------------------------------------------------------------------
// Função: TFterceiros - Carrega tabela com saldo EM e DE terceiros
//--------------------------------------------------------------------------------------------------------------
User Function TFterceiros( cAliasQry )
	Local cAliasPROC	:= GetNextAlias()
	Local _cQuery

	If TCSPExist("SP_REL_MOVIMENTO_DIARIO_PODER3")
		If SM0->M0_CODIGO='01'
			_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO_PODER3 '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO_PODER3
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
		EndIf
		If SM0->M0_CODIGO='02'
			_cQuery := "EXEC SP_REL_MOVIMENTO_DIARIO_PODER3_MERCABEL '"+Dtos(mv_par01)+"', '"+Dtos(mv_par02)+"', '"+mv_par03+"', '"+mv_par04+"', '"+mv_par05+"', '"+mv_par06+"', '"+xFilial("SD1")+"'"
			/*
				Parametros da procedure SP_REL_MOVIMENTO_DIARIO_PODER3
				@DINICIO VARCHAR(10),
				@DFINAL VARCHAR(10),
				@CPRODUTOINI VARCHAR(9),
				@CPRODUTOFIN VARCHAR(9),
				@CLOCALINI VARCHAR(2),
				@CTIPOINI VARCHAR(2),
				@CFILIAL VARCHAR(2)
			*/
		EndIf

		If Select( (cAliasPROC) ) > 0
			dbSelectArea( (cAliasPROC) )
			DbCloseArea()
		EndIf

		TCQUERY _cQuery NEW ALIAS (cAliasPROC)

		(cAliasPROC)->(DbGotop())
		While !(cAliasPROC)->(Eof())
			cChave := (cAliasPROC)->ID_PRODUTO
			cChave += (cAliasPROC)->ID_LOCAL
			cChave += (cAliasPROC)->B6_TIPO
			If (cAliasPROC)->ZAJ_TIPO != "X"
				If !(cAliasQry)->(DbSeek( cChave ))
					RecLock((cAliasQry),.T.)
					(cAliasQry)->ID_CHAVE	:= cChave
					(cAliasQry)->SLD_INI		:= (cAliasPROC)->SLD_INICIAL
					(cAliasQry)->QT_MOVTO	:= (cAliasPROC)->TT_QUANT
					(cAliasQry)->VL_CUSTO	:= (cAliasPROC)->VL_CUSTO
					(cAliasQry)->CD_PRODT	:= (cAliasPROC)->ID_PRODUTO
					(cAliasQry)->B6_TIPO		:= (cAliasPROC)->B6_TIPO
					(cAliasQry)->NM_ARMAZ	:= (cAliasPROC)->NM_ARMAZ
					(cAliasQry)->NM_PRODT	:= (cAliasPROC)->NM_PRODUTO
					(cAliasQry)->ID_LOCAL	:= (cAliasPROC)->ID_LOCAL
					(cAliasQry)->B1_TIPO		:= (cAliasPROC)->B1_TIPO
					(cAliasQry)->(MsUnlock())
				Else
					RecLock((cAliasQry),.F.)
					(cAliasQry)->QT_MOVTO	+= (cAliasPROC)->TT_QUANT
					(cAliasQry)->(MsUnlock())
				EndIf
			EndIf
			(cAliasPROC)->(DbSkip())
		End

	EndIf

Return
