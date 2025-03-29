-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _GLOBAL
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------
-- Table: _GLOBAL.DBFASES
-- -----------------------------------------------------------------------------------------

DROP VIEW IF  EXISTS _rodadaconfig.vwrodadafases;
DROP TABLE IF  EXISTS _rodadaconfig.dbrodadafase;
DROP TABLE IF  EXISTS _global.dbfase;

CREATE TABLE IF NOT EXISTS _global.dbfase
(
    id 				    SERIAL NOT NULL ,
    indtipofase 	    integer NOT NULL,
    nome 			    character varying(40),
    ordem 	            integer not null,
    qtddias 	        integer not NULL,
    corgestao           text not NULL,        
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer NOT NULL,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbfase PRIMARY KEY (id),

    CONSTRAINT unq_tipopb_nome UNIQUE (indtipofase, nome) INCLUDE(indtipofase, nome),
	
    CONSTRAINT fk_dbfase_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbfase_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbfase_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

COMMENT ON TABLE  _global.dbfase                        IS 'Registro das fases de eventos';
COMMENT ON COLUMN _global.dbfase.id		     	        IS 'PK da tabela';
COMMENT ON COLUMN _global.dbfase.indtipofase 		    IS 'Tipo de identificação da fase';
COMMENT ON COLUMN _global.dbfase.nome 			        IS 'Nome da fase';
COMMENT ON COLUMN _global.dbfase.ordem              	IS 'Ordem de execução da fase';
COMMENT ON COLUMN _global.dbfase.qtddias		        IS 'Qtd. de dias de duração da fase';

ALTER TABLE IF EXISTS _global.dbfase OWNER to postgres;
GRANT ALL ON TABLE _global.dbfase TO n2espindesenv;
GRANT ALL ON TABLE _global.dbfase TO postgres;
GRANT ALL ON SEQUENCE _global.dbfase_id_seq TO n2espindesenv; 


INSERT INTO "_global".dbfase (indtipofase,nome,ordem,qtddias,corgestao,inc_data,inc_idusuario,alt_data,alt_idusuario,exc_data,exc_idusuario) VALUES
	 (1,'Configuração da Rodada',1,8,'#C04747','2024-11-13 11:24:14.745331',1,NULL,NULL,NULL,NULL),
	 (1,'Confirmação dos Juízes',2,20,'#668BC6','2024-11-13 11:24:58.653397',1,NULL,NULL,NULL,NULL),
	 (1,'Votação Juízes',3,30,'#5AB34B','2024-11-13 11:25:44.393364',1,NULL,NULL,NULL,NULL);


-- -----------------------------------------------------------------------------------------
-- Table: _RODADACONFIG.DBRODADAFASES
-- -----------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadafase
(
    id 				    SERIAL NOT NULL ,
    idrodada 	        integer NOT NULL,
    idfase 			    integer NOT NULL,
    dataprevistainicio  TIMESTAMP WITHOUT TIME ZONE,
    dataprevistafim     TIMESTAMP WITHOUT TIME ZONE,
    qtddias 	        integer,    
    flgconcluida        character(1) DEFAULT 'N',    
    CONSTRAINT pk_dbrodadafase PRIMARY KEY (id),

    CONSTRAINT fk_dbrodada_idrodada FOREIGN KEY (idrodada)
        REFERENCES _cadbasicos.dbrodada (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
	
    CONSTRAINT fk_dbfase_idfase FOREIGN KEY (idfase)
        REFERENCES _global.dbfase (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

COMMENT ON TABLE  _rodadaconfig.dbrodadafase                      IS 'Registro das fases de execução da Rodada';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.id		     	      IS 'PK da tabela';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.idrodada 			  IS 'FK da tabela de Rodada';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.idfase 			  IS 'FK da tabela de Fase';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.dataprevistainicio   IS 'Data prevista de inicio da fase da rodada';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.dataprevistafim	  IS 'Data prevista de termino da fase da rodada';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.qtddias		      IS 'Qtd. de dias de duração da fase da rodada';
COMMENT ON COLUMN _rodadaconfig.dbrodadafase.flgconcluida         IS 'Indicar se a fase da rodada foi concuída ou não';

ALTER TABLE IF EXISTS _rodadaconfig.dbrodadafase OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadafase TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadafase TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadafase_id_seq TO n2espindesenv; 

INSERT INTO "_rodadaconfig".dbrodadafase (idrodada,idfase,dataprevistainicio,dataprevistafim,qtddias) VALUES
	 (1,1,'2024-11-13 00:00:00','2024-11-15 23:59:59',3),
	 (1,2,'2024-11-16 00:00:00','2024-11-19 23:59:59',4),
	 (1,3,'2024-11-20 00:00:00','2024-11-22 23:59:59',3),
	 (2,1,'2024-11-13 00:00:00','2024-11-14 23:59:59',2),
	 (2,2,'2024-11-15 00:00:00','2024-11-17 23:59:59',3),
	 (2,3,'2024-11-18 00:00:00','2024-11-19 23:59:59',2);

-- -----------------------------------------------------------------------------------------
-- Table: _RODADACONFIG.VWRODADAFASES
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW "_rodadaconfig".vwrodadafases
AS SELECT dbrf.id,
    dbdomstrdd.valordominio AS valortipofase,
    dbrf.idrodada,
    d.nome AS nomerodada,
    d.sigla AS siglarodada,
    (TRIM(BOTH FROM d.nome) || ' - '::text) || TRIM(BOTH FROM d.sigla) AS nomesiglarodada,   
    dbrf.idfase,
    f.nome AS nomefase,
    f.corgestao,
    f.ordem,
    dbrf.dataprevistainicio,
    dbrf.dataprevistafim,
    to_char(dbrf.dataprevistainicio::timestamp with time zone, 'DD/MM/YYYY'::text) AS formatdataprevistainicio,
    to_char(dbrf.dataprevistafim::timestamp with time zone, 'DD/MM/YYYY'::text) AS formatdataprevistafim,
    dbrf.qtddias,
    dbrf.flgconcluida,
      CASE
            WHEN (dbrf.dataprevistafim::date - now()::date + 1) <= dbrf.qtddias THEN (dbrf.dataprevistafim::date - now()::date + 1)::numeric / dbrf.qtddias::numeric 
            ELSE 0::numeric
        END AS percandamento,
   (dbrf.dataprevistafim::date - now()::date + 1) as qtddiaspassados
   FROM _rodadaconfig.dbrodadafase dbrf
     LEFT JOIN _cadbasicos.dbrodada d ON d.id = dbrf.idrodada
     LEFT JOIN _global.dbfase f ON f.id = dbrf.idfase
     LEFT JOIN _global.dbcampodominio dbdomstrdd ON dbdomstrdd.grupodominio = 'tfs'::bpchar AND dbdomstrdd.indicedominio = f.indtipofase
  ORDER BY dbrf.idrodada, dbrf.idfase, f.ordem;

ALTER TABLE IF EXISTS _rodadaconfig.vwrodadafases OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadafases TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadafases TO postgres;


