package br.com.diego.lab.persistencia.pocs.poc01_banco_vs_aplicacao.runner;

import br.com.diego.lab.persistencia.pocs.poc01_banco_vs_aplicacao.orm.OrmComFiltroService;
import br.com.diego.lab.persistencia.pocs.poc01_banco_vs_aplicacao.orm.OrmSemFiltroService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class BancoVsAplicacaoRunner implements CommandLineRunner {

    private final OrmSemFiltroService ormSemFiltroService;
    private final OrmComFiltroService ormComFiltroService;

    public BancoVsAplicacaoRunner(
            OrmSemFiltroService ormSemFiltroService,
            OrmComFiltroService ormComFiltroService
    ) {
        this.ormSemFiltroService = ormSemFiltroService;
        this.ormComFiltroService = ormComFiltroService;
    }

    @Override
    public void run(String... args) {
        System.out.println("======================================");
        System.out.println(" POC01 - Banco vs Aplicação (ORM)");
        System.out.println("======================================");

        executarCenario("50k",
                ormSemFiltroService::buscarAtivos50k,
                ormComFiltroService::buscarAtivos50k
        );

        executarCenario("500k",
                ormSemFiltroService::buscarAtivos500k,
                ormComFiltroService::buscarAtivos500k
        );

        executarCenario("5kk",
                ormSemFiltroService::buscarAtivos5kk,
                ormComFiltroService::buscarAtivos5kk
        );

        System.out.println("\n======================================");
        System.out.println(" FIM DA POC01 - ORM");
        System.out.println("======================================");
    }

    private void executarCenario(
            String volume,
            ResultadoSupplier semFiltro,
            ResultadoSupplier comFiltro
    ) {
        System.out.println("\n--- CENÁRIO: " + volume + " registros ---");
        System.out.println(semFiltro.get());
        System.out.println(comFiltro.get());
    }

    @FunctionalInterface
    private interface ResultadoSupplier {
        ResultadoExecucao get();
    }
}