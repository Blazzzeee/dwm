import google.generativeai as genai
import sys

# Configure the Gemini API
genai.configure(api_key="AIzaSyCkMn2Xnk2-eE4QgvK-1nmcW_NgXX6e644")
model = genai.GenerativeModel('gemini-1.5-flash-002')

# Get the query from the command-line arguments
if len(sys.argv) > 1:
    query = sys.argv[1]
    try:
        response = model.generate_content(query)
        print(response.text)
    except Exception as e:
        print(f"Error during Gemini API call: {e}")
else:
    print("No query provided.")
