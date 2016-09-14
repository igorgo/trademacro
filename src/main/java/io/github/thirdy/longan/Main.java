/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.thirdy.longan;

import java.io.IOException;
import static java.util.Arrays.asList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import static java.util.stream.Collectors.joining;
import org.apache.commons.lang3.exception.ExceptionUtils;


/**
 *
 * @author sj
 */
public class Main {

    private static Logger logger = Logger.getLogger(Main.class.getName());
    
    public static void main(String[] args) throws IOException  {
        try {
            new Main(args);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
            Util.overwriteFile("results.txt", ExceptionUtils.getStackTrace(ex));
        }
    }
    
    CommandLine cl;
    BackendClient backendClient;

    Main(String[] args) throws Exception {
        cl = new CommandLine();
        cl.saveFlagValue("-l");
        cl.saveFlagValue("-p");
        cl.parse(args);
        backendClient = new BackendClient();
        
        int noOfItems = Integer.parseInt(cl.getFlagValue("-l"));
        String payload = cl.getFlagValue("-p");
        
        logger.info("Unencoded payload: " + payload);
	payload = asList(payload.split("&")).stream().map(Util::encodeQueryParm).collect(joining("&"));
        logger.info("Encoded payload: " + payload);
			String url = "http://poe.trade/search";
		String location = backendClient.post(url, payload);
                
        String html = backendClient.get(location);
        
        SearchPageScraper scraper = new SearchPageScraper(html);
        List<SearchPageScraper.SearchResultItem> items =  scraper.parse();
        String result = items.stream().limit(noOfItems).map(i -> outputItem(i)).collect(Collectors.joining("\r\n"));
        System.out.println(result);
        Util.overwriteFile("results.txt", result);
    }

    private String outputItem(SearchPageScraper.SearchResultItem i) {
        String output = i.name;
        if (i.corrupted) output = "[c]" + output;
        output = output + "->" + i.buyout;
        
        if (cl.hasFlag("-f")) {
            // TODO, maybe provide a string formatter?
            output = i.toString();
        }
        
        return output;
    } 
   
}
