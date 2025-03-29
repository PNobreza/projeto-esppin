
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _rodadaconfig - 
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

SET search_path TO _rodadaconfig, public;

-- -----------------------------------------------------------------------------------------
-- Table: _global.DBMODELOEMAIL
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _global.dbmodeloemail
(
    id 				    SERIAL NOT NULL ,
    tipomodeloemail	    INTEGER NOT NULL,
    titulo              VARCHAR(200) NOT NULL,
    textomensagem       TEXT,
    ativo 			    CHARACTER(1) DEFAULT 'S'::bpchar,
    CONSTRAINT pk_dbmodeloemail PRIMARY KEY (id)
)
TABLESPACE pg_default; 
COMMENT ON TABLE  _global.dbmodeloemail           IS 'Tabela de Modelos/Templates de Emails do sistema.';
COMMENT ON COLUMN _global.dbmodeloemail.id		IS 'PK da tabela';
COMMENT ON COLUMN _global.dbmodeloemail.tipomodeloemail	IS 'identifica o tipo do modelo, se: Convite, Login...';
COMMENT ON COLUMN _global.dbmodeloemail.titulo    IS 'Identificação do Modelo - Assunto do Email';
COMMENT ON COLUMN _global.dbmodeloemail.corpo		IS 'Mensagem / Corpo do Email - Texto/HTML com Variaveis taggeadas';

ALTER TABLE _global.dbmodeloemail OWNER TO postgres;
GRANT ALL ON TABLE _global.dbmodeloemail TO n2espindesenv;
GRANT ALL ON TABLE _global.dbmodeloemail TO postgres;
GRANT ALL ON SEQUENCE _global.dbmodeloemail_id_seq TO n2espindesenv; 

-- -----------------------------------------------------------------------------------------
-- Table: _adm.dbprocessamentoassincrono
-- -----------------------------------------------------------------------------------------
-- "_adm".dbprocessamentoassincrono definição

-- Drop table

-- DROP TABLE "_adm".dbprocessamentoassincrono;

CREATE TABLE "_adm".dbprocessamentoassincrono (
	id serial4 NOT NULL, -- PK da tabela
	idfuncionalidade int4 NOT NULL,
	data_requisicao timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	email_origem varchar(300) NOT NULL,
	email_destino varchar(300) NOT NULL,
	email_cc varchar(300) NULL,
	email_assunto varchar(200) NOT NULL,
	email_mensagem text NULL, -- Corpo do Email - Texto ou interpolação gerada com o Modelo + Variaveis
	idmodeloemail int4 NULL,
	email_variaveis jsonb NULL, -- Variaveis JSON contendo os dados de para serem aplicados nos modelos)
	atualizacao_retorno jsonb NULL, -- Variaveis JSON contendo dados para atualizações de retorno. Ex.: Nome tabela, clausula where e set
	sitprocessamento int4 DEFAULT 1 NULL,
	msg_retorno_proc text NULL,
	fks_apoio jsonb NULL,	
	inc_data timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	inc_idusuario int4 NULL,
    anexos jsonb NULL, -- Anexos
    flgreprocessamento
	CONSTRAINT pk_dbprocessamentoassincrono PRIMARY KEY (id)
);
COMMENT ON TABLE "_adm".dbprocessamentoassincrono IS 'Tabela de processamento assincrono da fila de envio de emails do sistema.';

-- Column comments

COMMENT ON COLUMN "_adm".dbprocessamentoassincrono.id IS 'PK da tabela';
COMMENT ON COLUMN "_adm".dbprocessamentoassincrono.email_mensagem IS 'Corpo do Email - Texto ou interpolação gerada com o Modelo + Variaveis';
COMMENT ON COLUMN "_adm".dbprocessamentoassincrono.email_variaveis IS 'Variaveis JSON contendo os dados de para serem aplicados nos modelos)';
COMMENT ON COLUMN "_adm".dbprocessamentoassincrono.atualizacao_retorno IS 'Variaveis JSON contendo dados para atualizações de retorno. Ex.: Nome tabela, clausula where e set';

-- Permissions

ALTER TABLE "_adm".dbprocessamentoassincrono OWNER TO postgres;
GRANT ALL ON TABLE "_adm".dbprocessamentoassincrono TO postgres;
GRANT ALL ON TABLE "_adm".dbprocessamentoassincrono TO n2espindesenv;
GRANT ALL ON SEQUENCE _adm.dbprocessamentoassincrono_id_seq TO n2espindesenv; 

-- "_adm".dbprocessamentoassincrono chaves estrangeiras

ALTER TABLE "_adm".dbprocessamentoassincrono ADD CONSTRAINT fk_dbprocessamentoassincrono_idmodeloemail FOREIGN KEY (idmodeloemail) REFERENCES "_rodadaconfig".dbmodeloemail(id);
ALTER TABLE "_adm".dbprocessamentoassincrono ADD CONSTRAINT fk_dbprocessamentoassincrono_user_inc FOREIGN KEY (inc_idusuario) REFERENCES "_adm".system_users(id);

-- -----------------------------------------------------------------------------------------
-- Table: _adm.vwprocessamentoassincrono
-- -----------------------------------------------------------------------------------------

-- _adm.vwprocessamentoassincrono 

CREATE OR REPLACE VIEW _adm.vwprocessamentoassincrono
AS SELECT dfe.id,
    dfe.idfuncionalidade,
    sp.name AS nomefuncionalidade,
    sp.controller AS classefuncionalidade,
    to_char(dfe.data_requisicao, 'DD/MM/YYYY HH24:MI'::text) AS data_requisicao,
    dfe.email_origem,
    dfe.email_destino,
    dfe.email_cc,
    dfe.email_assunto,
    dfe.email_mensagem,
    dfe.idmodeloemail,
    dme.titulo AS modelotitulo,
    dfe.atualizacao_retorno ->> 'schema'::text AS schema,
    dfe.atualizacao_retorno ->> 'tabela'::text AS tabela,
    dfe.atualizacao_retorno ->> 'campowhere1'::text AS campowhere1,
    dfe.atualizacao_retorno ->> 'campowhere2'::text AS campowhere2,
    dfe.atualizacao_retorno ->> 'valorcampowhere1'::text AS valorcampowhere1,
    dfe.atualizacao_retorno ->> 'valorcampowhere2'::text AS valorcampowhere2,
    dfe.atualizacao_retorno ->> 'camposet'::text AS camposet,
    dfe.sitprocessamento,
    cd.valordominio AS descsitprocessamento,
    dfe.msg_retorno_proc,
    dfe.fks_apoio ->> 'idrodada'::text AS idrodada,
    dr.nome AS nomerodada,
    dfe.email_variaveis ->> 'periodo'::text AS periodo,
    dfe.fks_apoio ->> 'idjuiz'::text AS idjuiz,
    vj.nome AS nomejuiz,
    dfe.inc_data,
    dfe.inc_idusuario,
    dfe.anexos,
     flgreprocessamento
   FROM _adm.dbprocessamentoassincrono dfe
     LEFT JOIN _global.system_program sp ON sp.id = dfe.idfuncionalidade
     LEFT JOIN _cadbasicos.dbrodada dr ON dr.id = ((dfe.fks_apoio ->> 'idrodada'::text)::integer)
     LEFT JOIN _cadbasicos.vwjuiz vj ON vj.id = ((dfe.fks_apoio ->> 'idjuiz'::text)::integer)
     JOIN _global.dbcampodominio cd ON cd.grupodominio::bpchar = 'spe'::bpchar AND cd.indicedominio = dfe.sitprocessamento
     LEFT JOIN _global.dbmodeloemail dme ON dme.id = dfe.idmodeloemail;

-- Permissions

ALTER TABLE _adm.vwprocessamentoassincrono OWNER TO postgres;
GRANT ALL ON TABLE _adm.vwprocessamentoassincrono TO postgres;
GRANT ALL ON TABLE _adm.vwprocessamentoassincrono TO n2espindesenv;