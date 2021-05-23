public class GenerateFormPDFExt {

    public GenerateFormPDFExt(ApexPages.StandardController controller) {

    }
    
    public String getPrintableView() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        String html = Test.isRunningTest()?'':new PageReference('/' + id + '/p').getContent().toString();
        return html.substringAfter('</head>').substringBefore('</html>');
    }

}