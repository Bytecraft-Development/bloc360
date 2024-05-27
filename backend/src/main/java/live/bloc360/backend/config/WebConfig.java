//package live.bloc360.backend.config;
//
//import org.springframework.context.annotation.Configuration;
//import org.springframework.web.servlet.config.annotation.CorsRegistry;
//import org.springframework.web.servlet.config.annotation.EnableWebMvc;
//import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//
//@Configuration
//@EnableWebMvc
//class WebConfig implements WebMvcConfigurer {
//
//    @Override
//    public void addCorsMappings(CorsRegistry registry) {
//        registry.addMapping("/**").allowedOrigins("http://localhost");
//        registry.addMapping("/**").allowedOrigins("https://localhost");
//        registry.addMapping("/**").allowedOrigins("http://bloc360.live");
//        registry.addMapping("/**").allowedOrigins("http://bloc360.live//**");
//        registry.addMapping("/**").allowedOrigins("http://bloc360.live/**");
//        registry.addMapping("/**").allowedOrigins("https://bloc360.live");
//        registry.addMapping("/**").allowedOrigins("https://bloc360.live:8443");
//        registry.addMapping("/**").allowedOrigins("https://bloc360.live:8080");
//        registry.addMapping("/**").allowedOrigins("https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token");
//    }
//}
//
