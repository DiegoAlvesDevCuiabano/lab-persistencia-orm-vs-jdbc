package br.com.diego.lab.persistencia.pocs.poc01_banco_vs_aplicacao.runner;

public record ResultadoExecucao(
        String estrategia,
        String volume,
        int registrosRetornados,
        long tempoMs
) {
    @Override
    public String toString() {
        String tempoFormatado = formatarTempo(tempoMs);
        return String.format("%-20s (%5s) -> registros: %,7d | tempo: %s",
                estrategia, volume, registrosRetornados, tempoFormatado);
    }

    private String formatarTempo(long ms) {
        if (ms < 1000) {
            return String.format("%dms", ms);
        }
        double segundos = ms / 1000.0;
        return String.format("%.2fs (%dms)", segundos, ms);
    }
}