/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.thirdy.longan;

import static java.util.Arrays.asList;
import java.util.List;
import java.util.stream.Collectors;
import static java.util.stream.Collectors.joining;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author sj
 */
public class Main {

    private final static Logger logger = LoggerFactory.getLogger(Main.class.getName());
    public static void main(String[] args) throws Exception {
        BackendClient backendClient = new BackendClient();
        String league = args[0];
        int noOfItems = Integer.parseInt(args[1]);
        String name = args[2];
        String payload = String.format("league=%s&type=&base=&name=%s&dmg_min=&dmg_max=&aps_min=&aps_max=&crit_min=&crit_max=&dps_min=&dps_max=&edps_min=&edps_max=&pdps_min=&pdps_max=&armour_min=&armour_max=&evasion_min=&evasion_max=&shield_min=&shield_max=&block_min=&block_max=&sockets_min=&sockets_max=&link_min=&link_max=&sockets_r=&sockets_g=&sockets_b=&sockets_w=&linked_r=&linked_g=&linked_b=&linked_w=&rlevel_min=&rlevel_max=&rstr_min=&rstr_max=&rdex_min=&rdex_max=&rint_min=&rint_max=&mod_name=&mod_min=&mod_max=&group_type=And&group_min=&group_max=&group_count=1&q_min=&q_max=&level_min=&level_max=&ilvl_min=&ilvl_max=&rarity=&seller=&thread=&identified=&corrupted=&online=x&buyout=x&altart=&capquality=x&buyout_min=&buyout_max=&buyout_currency=&crafted=&enchanted=",
                league, name);
        logger.info("Unencoded payload: " + payload);
	payload = asList(payload.split("&")).stream().map(Util::encodeQueryParm).collect(joining("&"));
        logger.info("Encoded payload: " + payload);
			String url = "http://poe.trade/search";
		String location = backendClient.post(url, payload);
                
        String html = backendClient.get(location);
        
        SearchPageScraper scraper = new SearchPageScraper(html);
        List<SearchPageScraper.SearchResultItem> items =  scraper.parse();
        String result = items.stream().limit(noOfItems).map(i -> i.name + "->" + i.buyout).collect(Collectors.joining("\r\n"));
        System.out.println(result);
        
        Util.overwriteFile("results.txt", result);
    }
    
}
