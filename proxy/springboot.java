package com.example.foo

import org.mitre.dsmiley.httpproxy.ProxyServlet;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HttpProxyServletConfiguration {

//	<dependency>
//	    <groupId>org.mitre.dsmiley.httpproxy</groupId>
//	    <artifactId>smiley-http-proxy-servlet</artifactId>
//	    <version>1.7</version>
//	</dependency>

	@Bean
	public ServletRegistrationBean servletRegistrationBean() {
		
		ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new ProxyServlet(),"/wx/weather/find");
		servletRegistrationBean.setName("p");
		servletRegistrationBean.addInitParameter("targetUri", "https://search.heweather.com/find");
		servletRegistrationBean.addInitParameter(ProxyServlet.P_LOG, "true");
		
		return servletRegistrationBean;
	}
	
	@Bean
	public ServletRegistrationBean servletRegistrationBean1() {
		
		ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new ProxyServlet(),"/wx/weather/detail");
		servletRegistrationBean.setName("p1");
		servletRegistrationBean.addInitParameter("targetUri", "https://widget-api.heweather.net/s6/plugin/h5");
		servletRegistrationBean.addInitParameter(ProxyServlet.P_LOG, "true");
		
		return servletRegistrationBean;
	}

	

}
