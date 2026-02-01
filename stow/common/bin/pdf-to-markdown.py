#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["PyPDF2"]
# requires-python = ">=3.8"
# ///

import argparse
import sys
from pathlib import Path

import PyPDF2


def extract_text_from_pdf(pdf_path):
    """Extract text from PDF file."""
    try:
        with open(pdf_path, 'rb') as file:
            pdf_reader = PyPDF2.PdfReader(file)
            text = ""
            for page_num, page in enumerate(pdf_reader.pages, 1):
                page_text = page.extract_text()
                if page_text.strip():
                    text += f"\n\n## Page {page_num}\n\n"
                    text += page_text
            return text
    except Exception as e:
        print(f"Error reading PDF: {e}", file=sys.stderr)
        sys.exit(1)


def convert_to_markdown(text, title=None):
    """Convert extracted text to markdown format."""
    markdown = ""
    
    if title:
        markdown += f"# {title}\n\n"
    
    # Clean up the text and add basic markdown formatting
    lines = text.split('\n')
    for line in lines:
        line = line.strip()
        if line:
            markdown += line + "\n"
        else:
            markdown += "\n"
    
    return markdown


def main():
    parser = argparse.ArgumentParser(description='Convert PDF to Markdown')
    parser.add_argument('pdf_file', help='Input PDF file path')
    parser.add_argument('-o', '--output', help='Output markdown file path (default: same name as PDF with .md extension)')
    parser.add_argument('-t', '--title', help='Title for the markdown document')
    
    args = parser.parse_args()
    
    # Validate input file
    pdf_path = Path(args.pdf_file)
    if not pdf_path.exists():
        print(f"Error: PDF file '{args.pdf_file}' not found", file=sys.stderr)
        sys.exit(1)
    
    if not pdf_path.suffix.lower() == '.pdf':
        print(f"Error: '{args.pdf_file}' is not a PDF file", file=sys.stderr)
        sys.exit(1)
    
    # Determine output file
    if args.output:
        output_path = Path(args.output)
    else:
        output_path = pdf_path.with_suffix('.md')
    
    # Extract text from PDF
    print(f"Extracting text from {pdf_path}...")
    extracted_text = extract_text_from_pdf(pdf_path)
    
    # Convert to markdown
    title = args.title or pdf_path.stem
    markdown_content = convert_to_markdown(extracted_text, title)
    
    # Write to output file
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(markdown_content)
        print(f"Successfully converted to {output_path}")
    except Exception as e:
        print(f"Error writing output file: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
