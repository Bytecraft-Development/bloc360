package live.bloc360.backend.service;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.Payment;
import live.bloc360.backend.repository.HouseHoldRepository;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.xhtmlrenderer.pdf.ITextRenderer;

import java.io.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Service
public class InvoiceGeneratorService {
    private final HouseHoldRepository houseHoldRepository;
    private final TemplateEngine templateEngine;
    //File outputPdf = new File("C:\\Users\\andi1\\IdeaProjects\\bloc360\\backend\\src\\main\\resources\\templates\\outputPdf360.pdf");
    //File outputPdf = new File("..\\..\\..\\resources\\templates\\outputPdf360.pdf");
    File outputPdf = new File("outputPdf360.pdf");

    public InvoiceGeneratorService(HouseHoldRepository houseHoldRepository, TemplateEngine templateEngine) {
        this.templateEngine = templateEngine;
        this.houseHoldRepository = houseHoldRepository;
    }

    public Document convertHtmlToJsoupDocument(Integer houseHoldId) throws IOException {
        Document document = Jsoup.parse(generateInvoiceHtml(houseHoldId));
        document.outputSettings().syntax(Document.OutputSettings.Syntax.xml);
        return document;
    }

    public void createPDF(Integer houseHoldId){
        try (OutputStream outputStream = new FileOutputStream(outputPdf)) {
            ITextRenderer renderer = new ITextRenderer();

            Document document = convertHtmlToJsoupDocument(houseHoldId);
            String xhtmlContent = document.outerHtml(); // Convert Jsoup Document to XHTML string
            renderer.setDocumentFromString(xhtmlContent);

            renderer.layout();
            renderer.createPDF(outputStream);
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public String generateInvoiceHtml(Integer houseHoldId) {
        Context context = new Context();
        HouseHold houseHold = houseHoldRepository.findById(houseHoldId)
                .orElseThrow(() -> new RuntimeException("Household not found"));
        context.setVariable("houseHold", houseHold);
        BigDecimal totalPaymentValue = houseHold.getPaymentList()
                .stream()
                .map(Payment::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        context.setVariable("totalPaymentValue", totalPaymentValue);
        return templateEngine.process("invoice", context);
    }
}

