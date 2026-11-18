package id.cbs.syariah;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.modulith.Modulithic;

@Modulithic(sharedModules = "shared")
@SpringBootApplication
public class CbsSyariahApplication {

    public static void main(String[] args) {
        SpringApplication.run(CbsSyariahApplication.class, args);
    }
}
