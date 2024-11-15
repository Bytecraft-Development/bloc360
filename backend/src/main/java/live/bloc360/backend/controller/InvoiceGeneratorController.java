package live.bloc360.backend.controller;

import live.bloc360.backend.service.InvoiceGeneratorService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
@RestController
@RequestMapping("/generator")
public class InvoiceGeneratorController {

    private final InvoiceGeneratorService invoiceGeneratorService;

    public InvoiceGeneratorController(InvoiceGeneratorService invoiceGeneratorService) {
        this.invoiceGeneratorService = invoiceGeneratorService;
    }

    @GetMapping("/generate")
    public void convert(@RequestParam(name = "houseHoldId") Integer houseHoldId) throws IOException {
        invoiceGeneratorService.convertHtmlToJsoupDocument(houseHoldId);
        invoiceGeneratorService.createPDF(houseHoldId);
    }
}
