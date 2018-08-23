package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
		
		return "home";
	}
	
	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public void ajaxTest() {
				
	}
	
	@RequestMapping(value = "/doA", method = RequestMethod.GET)
	public String doA() {
		System.out.println("doA 실행...");
		
		return "home";
	}
	
	@RequestMapping(value = "/doB", method = RequestMethod.GET)
	public String doB(Model model) {
		System.out.println("doB 실행...");
		model.addAttribute("result","DoB 결과");
		
		return "home";
	}
	
}
